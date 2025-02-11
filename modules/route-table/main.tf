locals {
  # List of maps with key and route values
  vpc_attachments_with_routes = chunklist(flatten([
    for k, v in var.vpc_attachments : setproduct([{ key = k }], v.tgw_routes) if can(v.tgw_routes)
  ]), 2)

  vpc_route_table_destination_cidr = flatten([
    for k, v in var.vpc_attachments : [
      for rtb_id in try(v.vpc_route_table_ids, []) : {
        rtb_id = rtb_id
        cidr   = v.tgw_destination_cidr
      }
    ]
  ])
}

################################################################################
# VPC Attachment
################################################################################

resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  for_each = var.vpc_attachments

  transit_gateway_id = var.transit_gateway_id
  vpc_id             = each.value.vpc_id
  subnet_ids         = each.value.subnet_ids

  dns_support                                     = try(each.value.dns_support, var.enable_dns_support) ? "enable" : "disable"
  ipv6_support                                    = try(each.value.ipv6_support, var.enable_ipv6_support) ? "enable" : "disable"
  security_group_referencing_support              = try(each.value.security_group_referencing_support, var.enable_sg_referencing_support) ? "enable" : "disable"
  transit_gateway_default_route_table_association = try(each.value.transit_gateway_default_route_table_association, var.enable_default_route_table_association)
  transit_gateway_default_route_table_propagation = try(each.value.transit_gateway_default_route_table_propagation, var.enable_default_route_table_propagation)

  tags = merge(
    var.tags,
    { Name = var.name },
    var.tgw_vpc_attachment_tags,
    try(each.value.tags, {}),
  )
}

################################################################################
# Route Table / Routes
################################################################################

resource "aws_ec2_transit_gateway_route_table" "this" {
  transit_gateway_id = var.transit_gateway_id

  tags = merge(
    var.tags,
    { Name = var.name },
    var.tgw_route_table_tags,
  )
}

resource "aws_ec2_transit_gateway_route" "this" {
  count = length(local.vpc_attachments_with_routes)

  destination_cidr_block = local.vpc_attachments_with_routes[count.index][1].destination_cidr_block
  blackhole              = try(local.vpc_attachments_with_routes[count.index][1].blackhole, null)

  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this.id
  transit_gateway_attachment_id  = tobool(try(local.vpc_attachments_with_routes[count.index][1].blackhole, false)) == false ? aws_ec2_transit_gateway_vpc_attachment.this[local.vpc_attachments_with_routes[count.index][0].key].id : null
}

resource "aws_ec2_transit_gateway_route_table_association" "this" {
  for_each = {
    for k, v in var.vpc_attachments : k => v if try(v.transit_gateway_default_route_table_association, var.enable_default_route_table_association) != true
  }

  # Create association if it was not set already by aws_ec2_transit_gateway_vpc_attachment resource
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.this[each.key].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "this" {
  for_each = {
    for k, v in var.vpc_attachments : k => v if try(v.transit_gateway_default_route_table_propagation, var.enable_default_route_table_propagation) != true
  }

  # Create association if it was not set already by aws_ec2_transit_gateway_vpc_attachment resource
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.this[each.key].id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this.id
}

resource "aws_route" "this" {
  for_each = { for x in local.vpc_route_table_destination_cidr : x.rtb_id => {
    cidr = x.cidr,
  } }

  route_table_id              = each.key
  destination_cidr_block      = try(each.value.ipv6_support, false) ? null : each.value["cidr"]
  destination_ipv6_cidr_block = try(each.value.ipv6_support, false) ? each.value["cidr"] : null
  transit_gateway_id          = var.transit_gateway_id
}
