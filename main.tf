
provider "aws" {
  region = var.accepter_region
  alias  = "accepter"
}

locals {
  enable_peering = var.enable_peering && !var.create_tgw

  tags = merge(
    var.tags,
    {
      Module = "terraform-aws-transit-gateway"
    }
  )

  tgw_default_route_table_tags_merged = merge(
    local.tags,
    { Name = var.name },
    var.tgw_default_route_table_tags,
  )

  tgw_peering_attachments        = var.enable_peering ? var.tgw_peering_attachments : {}
  tgw_peering_route_table_routes = local.enable_peering ? { for r in var.tgw_peering_route_table_routes : "${r.peering_attachment_key}-${r.destination_cidr_block}" => r } : {}

  vpc_attachments_with_routes = chunklist(flatten([
    for k, v in var.vpc_attachments : setproduct([{ key = k }], v.tgw_routes) if var.create_tgw && can(v.tgw_routes)
  ]), 2)

  vpc_route_table_destination_cidr = flatten([
    for k, v in var.vpc_attachments : [
      for rtb_id in try(v.vpc_route_table_ids, []) : [
        for tgw_route in try(v.tgw_routes, []) : {
          vpc_attachment_id = k
          rtb_id            = rtb_id
          cidr              = tgw_route.destination_cidr_block
          tgw_id            = v.tgw_id
        }
      ]
    ]
  ])
}

################################################################################
# Transit Gateway
################################################################################

resource "aws_ec2_transit_gateway" "this" {
  count = var.create_tgw ? 1 : 0

  amazon_side_asn                 = var.amazon_side_asn
  auto_accept_shared_attachments  = var.enable_auto_accept_shared_attachments ? "enable" : "disable"
  default_route_table_association = var.enable_default_route_table_association ? "enable" : "disable"
  default_route_table_propagation = var.enable_default_route_table_propagation ? "enable" : "disable"
  description                     = coalesce(var.description, var.name)
  dns_support                     = var.enable_dns_support ? "enable" : "disable"
  multicast_support               = var.enable_multicast_support ? "enable" : "disable"
  transit_gateway_cidr_blocks     = var.transit_gateway_cidr_blocks
  vpn_ecmp_support                = var.enable_vpn_ecmp_support ? "enable" : "disable"

  timeouts {
    create = try(var.timeouts.create, null)
    delete = try(var.timeouts.delete, null)
    update = try(var.timeouts.update, null)
  }

  tags = merge(
    local.tags,
    { Name = var.name },
    var.tgw_tags,
  )
}

resource "aws_ec2_tag" "this" {
  for_each = var.create_tgw && var.enable_default_route_table_association && length(aws_ec2_transit_gateway.this) > 0 ? local.tgw_default_route_table_tags_merged : {}

  resource_id = length(aws_ec2_transit_gateway.this) > 0 ? aws_ec2_transit_gateway.this[0].association_default_route_table_id : ""

  key   = each.key
  value = each.value
}

################################################################################
# VPC Attachment
################################################################################

resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  for_each = var.vpc_attachments

  appliance_mode_support                          = try(each.value.appliance_mode_support, false) ? "enable" : "disable"
  dns_support                                     = try(each.value.dns_support, true) ? "enable" : "disable"
  ipv6_support                                    = try(each.value.ipv6_support, false) ? "enable" : "disable"
  subnet_ids                                      = each.value.subnet_ids
  transit_gateway_default_route_table_association = try(each.value.transit_gateway_default_route_table_association, true)
  transit_gateway_default_route_table_propagation = try(each.value.transit_gateway_default_route_table_propagation, true)
  transit_gateway_id                              = var.create_tgw ? aws_ec2_transit_gateway.this[0].id : each.value.tgw_id
  vpc_id                                          = each.value.vpc_id

  tags = merge(
    local.tags,
    { Name = var.name },
    var.tgw_vpc_attachment_tags,
    try(each.value.tags, {}),
  )
}

################################################################################
# Route Table / Routes
################################################################################

resource "aws_ec2_transit_gateway_route_table" "this" {
  count = var.create_tgw ? 1 : 0

  transit_gateway_id = aws_ec2_transit_gateway.this[0].id

  tags = merge(
    local.tags,
    { Name = var.name },
    var.tgw_route_table_tags,
  )
}

resource "aws_ec2_transit_gateway_route" "this" {
  count = length(local.vpc_attachments_with_routes)

  blackhole                      = try(local.vpc_attachments_with_routes[count.index][1].blackhole, null)
  destination_cidr_block         = local.vpc_attachments_with_routes[count.index][1].destination_cidr_block
  transit_gateway_attachment_id  = tobool(try(local.vpc_attachments_with_routes[count.index][1].blackhole, false)) == false ? aws_ec2_transit_gateway_vpc_attachment.this[local.vpc_attachments_with_routes[count.index][0].key].id : null
  transit_gateway_route_table_id = var.create_tgw ? aws_ec2_transit_gateway_route_table.this[0].id : var.transit_gateway_route_table_id
}

resource "aws_route" "this" {
  for_each = { for index, x in local.vpc_route_table_destination_cidr : "${x.tgw_id}-${x.rtb_id}-${x.cidr}" => { "rtb_id" : x.rtb_id, "cidr" : x.cidr, "tgw_id" : x.tgw_id } }

  destination_cidr_block = each.value.cidr
  route_table_id         = each.value.rtb_id
  transit_gateway_id     = var.create_tgw ? aws_ec2_transit_gateway.this[0].id : each.value.tgw_id
}

resource "aws_ec2_transit_gateway_route_table_association" "this" {
  for_each = {
    for k, v in var.vpc_attachments : k => v if var.create_tgw && try(v.transit_gateway_default_route_table_association, true) != true
  }

  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.this[each.key].id
  transit_gateway_route_table_id = var.create_tgw ? aws_ec2_transit_gateway_route_table.this[0].id : try(each.value.transit_gateway_route_table_id, var.transit_gateway_route_table_id)
}

resource "aws_ec2_transit_gateway_route_table_propagation" "this" {
  for_each = {
    for k, v in var.vpc_attachments : k => v if var.create_tgw && try(v.transit_gateway_default_route_table_propagation, true) != true
  }

  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.this[each.key].id
  transit_gateway_route_table_id = var.create_tgw ? aws_ec2_transit_gateway_route_table.this[0].id : try(each.value.transit_gateway_route_table_id, var.transit_gateway_route_table_id)
}

################################################################################
# Resource Access Manager
################################################################################

resource "aws_ram_principal_association" "this" {
  count = var.create_tgw && var.share_tgw ? length(var.ram_principals) : 0

  principal          = var.ram_principals[count.index]
  resource_share_arn = aws_ram_resource_share.this[0].arn
}

resource "aws_ram_resource_association" "this" {
  count = var.create_tgw && var.share_tgw ? 1 : 0

  resource_arn       = aws_ec2_transit_gateway.this[0].arn
  resource_share_arn = aws_ram_resource_share.this[0].id
}

resource "aws_ram_resource_share" "this" {
  count = var.create_tgw && var.share_tgw ? 1 : 0

  allow_external_principals = var.ram_allow_external_principals
  name                      = coalesce(var.ram_name, var.name)

  tags = merge(
    local.tags,
    { Name = coalesce(var.ram_name, var.name) },
    var.ram_tags,
  )
}

resource "aws_ram_resource_share_accepter" "this" {
  count = !var.create_tgw && var.share_tgw ? 1 : 0

  share_arn = var.ram_resource_share_arn
}

################################################################################
# Transit Gateway Peering
################################################################################

# Transit Gateway Peering Attachment
resource "aws_ec2_transit_gateway_peering_attachment" "this" {
  for_each = local.tgw_peering_attachments

  peer_account_id         = each.value.peer_account_id
  peer_region             = each.value.peer_region
  peer_transit_gateway_id = each.value.peer_acceptor_tgw_id
  transit_gateway_id      = var.peer_requester_tgw_id

  tags = merge(
    local.tags,
    { Name = replace("peering-${each.key}-${each.value.peer_region}", "_", "-") }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# Accept Transit Gateway Peering Attachment
resource "aws_ec2_transit_gateway_peering_attachment_accepter" "this" {
  provider = aws.accepter
  for_each = local.tgw_peering_attachments

  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.this[each.key].id

  tags = merge(
    local.tags,
    { Name = replace("peering-accepter-${each.key}-${each.value.peer_region}", "_", "-") }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# Transit Gateway Route Table
resource "aws_ec2_transit_gateway_route" "peering" {
  for_each = local.tgw_peering_route_table_routes

  destination_cidr_block         = each.value.destination_cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.this[each.value.peering_attachment_key].id
  transit_gateway_route_table_id = var.tgw_association_default_route_table_id

  depends_on = [aws_ec2_transit_gateway_peering_attachment_accepter.this]
}
