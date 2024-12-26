locals {
  # List of maps with key and route values
  attachments_with_route_keys = flatten([
    for attachment_key, attachment_value in var.attachments : [
      for route_key, route_value in try(attachment_value.tgw_routes, {}) : [
        for cidr_block in try(route_value.destination_cidr_blocks, ["no-cidrs-defined"]) : {
          accept_tgw_peering = try(attachment_value.accept_tgw_peering, null)
          attachment_id = {
            peering = try(
              aws_ec2_transit_gateway_peering_attachment.this[attachment_key].id,
              null
            )
            vpc = try(
              aws_ec2_transit_gateway_vpc_attachment.this[attachment_key].id,
              null
            )
          }[attachment_value.attachment_type]
          attachment_key  = attachment_key
          attachment_type = attachment_value.attachment_type
          create_routes   = try(attachment_value.create_routes, false)
          route_dest      = cidr_block
          route_key       = route_key
          # route_table                         = try(route_value.route_table, var.tgw_route_tables[0])
          route_value                         = route_value
          tgw_default_route_table_association = try(attachment_value.transit_gateway_default_route_table_association, true)
          tgw_default_route_table_propagation = try(attachment_value.transit_gateway_default_route_table_propagation, true)
        } if var.create && try(attachment_value.create_routes, false)
      ]
    ]
  ])

  tgw_route_table_propagations = flatten([
    for attachment_key, attachment_value in var.attachments : [
      for tgw_rtb_name, tgw_rtb_value in try(attachment_value.tgw_route_table_propagations, {}) : {
        attachment_id      = try(aws_ec2_transit_gateway_vpc_attachment.this[attachment_key].id, null)
        attachment_key     = attachment_key
        enable_propagation = try(tgw_rtb_value.enable, false)
        rtb_name           = tgw_rtb_name
      } if var.create &&
      try(attachment_value.create_routes, false) &&
      try(attachment_value.transit_gateway_default_route_table_propagation, true) == false &&
      attachment_value.attachment_type != "peering"
    ]
  ])

  vpc_route_table_destinations = flatten([
    for k, v in var.attachments : [
      for rtb_id in try(v.vpc_route_table_ids, []) : [
        for cidr in try(v.vpc_route_table_destination_cidrs, []) : {
          cidr              = cidr
          create_vpc_routes = try(v.create_vpc_routes, false)
          ipv6_support      = try(v.ipv6_support, false)
          rtb_id            = rtb_id
          tgw_id            = !var.create ? try(v.tgw_id, null) : null
        } if try(v.create_vpc_routes, false)
      ]
    ]
  ])
}

################################################################################
# Transit Gateway
################################################################################

locals {
  tgw_tags = merge(
    var.tags,
    { Name = var.name },
    var.tgw_tags,
  )
}

resource "aws_ec2_transit_gateway" "this" {
  count = var.create ? 1 : 0

  description                     = var.description
  amazon_side_asn                 = var.amazon_side_asn
  default_route_table_association = var.enable_default_route_table_association ? "enable" : "disable"
  default_route_table_propagation = var.enable_default_route_table_propagation ? "enable" : "disable"
  auto_accept_shared_attachments  = var.enable_auto_accept_shared_attachments ? "enable" : "disable"
  multicast_support               = var.enable_multicast_support ? "enable" : "disable"
  vpn_ecmp_support                = var.enable_vpn_ecmp_support ? "enable" : "disable"
  dns_support                     = var.enable_dns_support ? "enable" : "disable"
  transit_gateway_cidr_blocks     = var.transit_gateway_cidr_blocks

  timeouts {
    create = try(var.timeouts.create, null)
    update = try(var.timeouts.update, null)
    delete = try(var.timeouts.delete, null)
  }

  tags = local.tgw_tags
}

resource "aws_ec2_tag" "this" {
  for_each = { for k, v in local.tgw_tags : k => v if var.create && var.enable_default_route_table_association }

  resource_id = aws_ec2_transit_gateway.this[0].association_default_route_table_id
  key         = each.key
  value       = each.value
}

################################################################################
# VPC Attachment
################################################################################

resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  for_each = { for k, v in var.attachments : k => v if v.attachment_type == "vpc" && try(v.create_vpc_attachment, false) }

  transit_gateway_id = var.create ? aws_ec2_transit_gateway.this[0].id : each.value.tgw_id
  vpc_id             = each.value.vpc_id
  subnet_ids         = each.value.subnet_ids

  dns_support                                     = try(each.value.dns_support, true) ? "enable" : "disable"
  ipv6_support                                    = try(each.value.ipv6_support, false) ? "enable" : "disable"
  appliance_mode_support                          = try(each.value.appliance_mode_support, false) ? "enable" : "disable"
  transit_gateway_default_route_table_association = try(each.value.transit_gateway_default_route_table_association, null)
  transit_gateway_default_route_table_propagation = try(each.value.transit_gateway_default_route_table_propagation, null)

  tags = merge(
    var.tags,
    { Name = each.key },
    var.attachment_tags,
    try(each.value.tags, {}),
  )
}

resource "aws_ec2_transit_gateway_vpc_attachment_accepter" "this" {
  for_each = { for k, v in var.attachments : k => v if v.attachment_type == "vpc" && try(v.accept_vpc_attachment, false) }

  transit_gateway_attachment_id                   = aws_ec2_transit_gateway_vpc_attachment.this[0]
  transit_gateway_default_route_table_association = try(each.value.transit_gateway_default_route_table_association, null)
  transit_gateway_default_route_table_propagation = try(each.value.transit_gateway_default_route_table_propagation, null)

  tags = merge(
    var.tags,
    { Name = each.key },
    var.attachment_tags,
    try(each.value.tags, {}),
  )
}

################################################################################
# Route Table / Routes
################################################################################

resource "aws_ec2_transit_gateway_route_table" "this" {
  count = var.create && var.create_route_table ? 1 : 0

  transit_gateway_id = aws_ec2_transit_gateway.this[0].id

  tags = merge(
    var.tags,
    { Name = var.name },
    var.route_table_tags,
  )
}

resource "aws_ec2_transit_gateway_route" "this" {
  for_each = { for attachment_route in local.attachments_with_route_keys : "${attachment_route.attachment_key}-${attachment_route.route_table}-${attachment_route.route_dest}" => attachment_route if var.create && attachment_route.route_dest != "no-cidrs-defined" }

  destination_cidr_block = each.value.route_dest
  blackhole              = try(each.value.route_value.blackhole, null)

  transit_gateway_route_table_id = var.create ? aws_ec2_transit_gateway_route_table.this[0].id : var.transit_gateway_route_table_id
  transit_gateway_attachment_id  = try(each.value.route_value.blackhole, false) == false ? each.value.attachment_id : null
}


resource "aws_route" "this" {
  for_each = { for route in local.vpc_route_table_destinations : "${route.rtb_id}-${route.cidr}" => route if route.create_vpc_routes }

  route_table_id              = each.value.rtb_id
  destination_cidr_block      = try(each.value.ipv6_support, false) ? null : each.value.cidr
  destination_ipv6_cidr_block = try(each.value.ipv6_support, false) ? each.value.cidr : null
  transit_gateway_id          = aws_ec2_transit_gateway.this[0].id
}

resource "aws_ec2_transit_gateway_route_table_association" "this" {
  for_each = { for attachment_route in local.attachments_with_route_keys : "${attachment_route.attachment_key}-${attachment_route.route_table}" => attachment_route... if var.create && attachment_route.create_routes && attachment_route.accept_tgw_peering == null && attachment_route.tgw_default_route_table_association == false && contains(keys(aws_ec2_transit_gateway_route_table.this), attachment_route.route_table)
  }

  transit_gateway_attachment_id  = each.value[0].attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this[0].id

  depends_on = [
    aws_ec2_transit_gateway_peering_attachment.this,
  ]
}

resource "aws_ec2_transit_gateway_route_table_propagation" "this" {
  for_each = { for attachment in local.tgw_route_table_propagations : "${attachment.attachment_key}-${attachment.rtb_name}" => attachment if attachment.enable_propagation && contains(keys(aws_ec2_transit_gateway_route_table.this), attachment.rtb_name) }

  transit_gateway_attachment_id  = each.value.attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this[each.value.rtb_name].id
}

################################################################################
# Resource Access Manager
################################################################################

resource "aws_ram_resource_share" "this" {
  count = var.create && var.share_tgw ? 1 : 0

  name                      = coalesce(var.ram_name, var.name)
  allow_external_principals = var.ram_allow_external_principals

  tags = merge(
    var.tags,
    { Name = coalesce(var.ram_name, var.name) },
    var.ram_tags,
  )
}

resource "aws_ram_resource_association" "this" {
  count = var.create && var.share_tgw ? 1 : 0

  resource_arn       = aws_ec2_transit_gateway.this[0].arn
  resource_share_arn = aws_ram_resource_share.this[0].id
}

resource "aws_ram_principal_association" "this" {
  for_each = { for k, v in var.ram_principals : k => v if var.create && var.share_tgw }

  principal          = each.value
  resource_share_arn = aws_ram_resource_share.this[0].arn
}

################################################################################
# TGW Peering
################################################################################

resource "aws_ec2_transit_gateway_peering_attachment" "this" {
  for_each = { for k, v in var.attachments : k => v if v.attachment_type == "peering" && try(v.create_peering, false) }

  peer_account_id         = each.value.peer_account_id
  peer_region             = each.value.peer_region
  peer_transit_gateway_id = each.value.peer_tgw_id
  transit_gateway_id      = aws_ec2_transit_gateway.this[0].id

  tags = var.tags
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "this" {
  for_each = { for k, v in var.attachments : k => v if try(v.accept_tgw_peering, false) }

  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.this[each.key].id

  tags = var.tags
}

################################################################################
# Flow Log(s)
################################################################################

resource "aws_flow_log" "this" {
  for_each = { for k, v in var.flow_logs : "${v.key}-${v.dest_type}" => v if v.dest_enabled }

  log_destination_type = each.value.dest_type
  log_destination = {
    s3               = each.value.s3_dest_arn,
    cloud-watch-logs = each.value.cloudwatch_dest_arn
  }[each.value.dest_type]
  log_format         = try(each.value.log_format, null)
  iam_role_arn       = each.value.dest_type == "cloud-watch-logs" ? each.value.cloudwatch_iam_role_arn : null
  traffic_type       = try(each.value.traffic_type, "ALL")
  transit_gateway_id = each.value.key == "tgw" && var.create ? aws_ec2_transit_gateway.this[0].id : null
  transit_gateway_attachment_id = each.value.key != "tgw" ? lookup({
    vpc     = each.value.create_vpc_attachment ? aws_ec2_transit_gateway_vpc_attachment.this[each.value.key].id : null
    peering = each.value.create_peering ? aws_ec2_transit_gateway_peering_attachment.this[each.value.key].id : null
  }, each.value.attachment_type, null) : null
  # When transit_gateway_id or transit_gateway_attachment_id is specified, max_aggregation_interval must be 60 seconds (1 minute).
  max_aggregation_interval = 60

  dynamic "destination_options" {
    for_each = each.value.dest_type == "s3" ? [true] : []

    content {
      file_format                = try(each.value.file_format, "parquet")
      hive_compatible_partitions = try(each.value.hive_compatible_partitions, false)
      per_hour_partition         = try(each.value.per_hour_partition, true)
    }
  }

  tags = merge(
    var.tags,
    var.flow_log_tags,
  )
}
