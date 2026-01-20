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

  region = var.region

  amazon_side_asn                    = var.amazon_side_asn
  auto_accept_shared_attachments     = var.auto_accept_shared_attachments ? "enable" : "disable"
  default_route_table_association    = var.default_route_table_association ? "enable" : "disable"
  default_route_table_propagation    = var.default_route_table_propagation ? "enable" : "disable"
  description                        = var.description
  dns_support                        = var.dns_support ? "enable" : "disable"
  multicast_support                  = var.multicast_support ? "enable" : "disable"
  security_group_referencing_support = var.security_group_referencing_support ? "enable" : "disable"
  transit_gateway_cidr_blocks        = var.transit_gateway_cidr_blocks
  vpn_ecmp_support                   = var.vpn_ecmp_support ? "enable" : "disable"

  dynamic "timeouts" {
    for_each = var.timeouts == null ? [] : [var.timeouts]
    content {
      create = timeouts.value.create
      update = timeouts.value.update
      delete = timeouts.value.delete
    }
  }

  tags = local.tgw_tags
}

resource "aws_ec2_tag" "this" {
  for_each = { for k, v in local.tgw_tags : k => v if var.create && var.default_route_table_association }

  region = var.region

  resource_id = aws_ec2_transit_gateway.this[0].association_default_route_table_id
  key         = each.key
  value       = each.value
}

################################################################################
# VPC Attachment
################################################################################

resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  for_each = { for k, v in var.vpc_attachments : k => v if var.create }

  region = var.region

  appliance_mode_support                          = each.value.appliance_mode_support ? "enable" : "disable"
  dns_support                                     = each.value.dns_support ? "enable" : "disable"
  ipv6_support                                    = each.value.ipv6_support ? "enable" : "disable"
  security_group_referencing_support              = each.value.security_group_referencing_support ? "enable" : "disable"
  subnet_ids                                      = each.value.subnet_ids
  transit_gateway_default_route_table_association = each.value.transit_gateway_default_route_table_association
  transit_gateway_default_route_table_propagation = each.value.transit_gateway_default_route_table_propagation
  transit_gateway_id                              = aws_ec2_transit_gateway.this[0].id
  vpc_id                                          = each.value.vpc_id

  tags = merge(
    var.tags,
    { Name = "${var.name}-${each.key}" },
    each.value.tags,
  )
}

resource "aws_ec2_transit_gateway_vpc_attachment_accepter" "this" {
  for_each = { for k, v in var.vpc_attachments : k => v if var.create && v.accept_peering_attachment }

  region = var.region

  transit_gateway_attachment_id                   = aws_ec2_transit_gateway_vpc_attachment.this[0]
  transit_gateway_default_route_table_association = each.value.transit_gateway_default_route_table_association
  transit_gateway_default_route_table_propagation = each.value.transit_gateway_default_route_table_propagation

  tags = merge(
    var.tags,
    each.value.tags,
  )
}

################################################################################
# TGW Peering Attachment
################################################################################

resource "aws_ec2_transit_gateway_peering_attachment" "this" {
  for_each = { for k, v in var.peering_attachments : k => v if var.create }

  region = var.region

  peer_account_id         = each.value.peer_account_id
  peer_region             = each.value.peer_region
  peer_transit_gateway_id = each.value.peer_transit_gateway_id
  transit_gateway_id      = aws_ec2_transit_gateway.this[0].id

  tags = merge(
    var.tags,
    { Name = "${var.name}-${each.key}" },
    each.value.tags,
  )
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "this" {
  for_each = { for k, v in var.peering_attachments : k => v if var.create && v.accept_peering_attachment }

  region = var.region

  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.this[each.key].id

  tags = merge(
    var.tags,
    each.value.tags,
  )
}

################################################################################
# Resource Access Manager
################################################################################

locals {
  ram_name = try(coalesce(var.ram_name, var.name), "")
}

resource "aws_ram_resource_share" "this" {
  count = var.create && var.enable_ram_share ? 1 : 0

  region = var.region

  name                      = local.ram_name
  allow_external_principals = var.ram_allow_external_principals

  tags = merge(
    var.tags,
    { Name = local.ram_name },
    var.ram_tags,
  )
}

resource "aws_ram_resource_association" "this" {
  count = var.create && var.enable_ram_share ? 1 : 0

  region = var.region

  resource_arn       = aws_ec2_transit_gateway.this[0].arn
  resource_share_arn = aws_ram_resource_share.this[0].id
}

resource "aws_ram_principal_association" "this" {
  for_each = { for k, v in var.ram_principals : k => v if var.create && var.enable_ram_share }

  region = var.region

  principal          = each.value
  resource_share_arn = aws_ram_resource_share.this[0].arn
}
