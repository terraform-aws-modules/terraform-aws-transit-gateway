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
  for_each = { for k, v in var.vpc_attachments : k => v if var.create }

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
  for_each = { for k, v in var.vpc_attachments : k => v if var.create && try(v.accept_peering_attachment, false) }

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
# TGW Peering Attachment
################################################################################

resource "aws_ec2_transit_gateway_peering_attachment" "this" {
  for_each = { for k, v in var.peering_attachments : k => v if var.create }

  peer_account_id         = each.value.peer_account_id
  peer_region             = each.value.peer_region
  peer_transit_gateway_id = each.value.peer_tgw_id
  transit_gateway_id      = aws_ec2_transit_gateway.this[0].id

  tags = var.tags
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "this" {
  for_each = { for k, v in var.peering_attachments : k => v if var.create && try(v.accept_peering_attachment, false) }

  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.this[each.key].id

  tags = var.tags
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
# Flow Log(s)
################################################################################

resource "aws_flow_log" "this" {
  for_each = { for k, v in var.flow_logs : k => v if var.create && var.create_flow_log }

  log_destination_type = each.value.log_destination_type
  log_destination      = each.value.log_destination
  log_format           = try(each.value.log_format, null)
  iam_role_arn         = try(each.value.iam_role_arn, null)
  traffic_type         = try(each.value.traffic_type, null)
  transit_gateway_id   = aws_ec2_transit_gateway.this[0].id
  transit_gateway_attachment_id = try(
    aws_ec2_transit_gateway_vpc_attachment.this[each.value.vpc_attachment_key].id,
    aws_ec2_transit_gateway_peering_attachment.this[each.value.peering_attachment_key].id,
    null
  )
  # When transit_gateway_id or transit_gateway_attachment_id is specified, max_aggregation_interval must be 60 seconds (1 minute).
  max_aggregation_interval = max(try(each.value.max_aggregation_interval, null), 60)

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
