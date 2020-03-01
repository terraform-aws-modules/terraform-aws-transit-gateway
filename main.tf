locals {
  vpc_attachments_without_default_route_table_association = {
    for k, v in var.vpc_attachments : k => v if lookup(v, "transit_gateway_default_route_table_association", true) != true
  }

  vpc_attachments_without_default_route_table_propagation = {
    for k, v in var.vpc_attachments : k => v if lookup(v, "transit_gateway_default_route_table_propagation", true) != true
  }

  // List of maps with key and route values
  vpc_attachments_with_routes = chunklist(flatten([
    for k, v in var.vpc_attachments : setproduct([map("key", k)], v["tgw_routes"]) if length(lookup(v, "tgw_routes", {})) > 0
  ]), 2)

  map_of_logical_names_vpc_to_attachments_ids = { for vpc_name, attachment in aws_ec2_transit_gateway_vpc_attachment.this : vpc_name => attachment.id }

  map_of_logical_names_vpn_to_attachments_ids = { for vpn_name, attachment in data.aws_ec2_transit_gateway_vpn_attachment.this : vpn_name => attachment.id }

  map_of_logical_names_vpn_and_vpc_to_attachments_ids = merge(flatten([
    local.map_of_logical_names_vpc_to_attachments_ids,
    local.map_of_logical_names_vpn_to_attachments_ids
  ])...)

  transposed_map_of_routes_from_var_transit_route_tables_map = merge(flatten([[ # merge(flatten([<some_object>])...) is a workaround for merging list of maps (see https://github.com/hashicorp/terraform/issues/22404#issuecomment-579081472)
    for tr_rtb_name, tr_rtb_spec in var.transit_route_tables_map : {
      for cidr, attachment_name in transpose(tr_rtb_spec["static_routes"]) : "${tr_rtb_name}#${attachment_name[0]}#${cidr}" => {
        "destination_cidr_block" : cidr,
        "transit_gateway_route_table_name" : tr_rtb_name,
        "attachment_name" : attachment_name[0],
        "has_error_in_static_routes_of_transit_route_table" : (length(attachment_name) != 1 ? "${tr_rtb_name}" : "") # there should be only one name of attachment (or blackhole) per route
      }
    }
  ]])...)

  # resulting map structure: {<attachment_logical_name> : <tgw_route_table_logical_name>}
  transposed_map_of_associations_from_var_transit_route_tables_map = transpose({ for tr_rtb_name, tr_rtb_spec in var.transit_route_tables_map : tr_rtb_name => tr_rtb_spec["associations"] })

  map_of_propagations_from_var_transit_route_tables_map = merge(flatten([[
    for tr_rtb_name, tr_rtb_spec in var.transit_route_tables_map : {
      for propagation_name in tr_rtb_spec["propagations"] : "${tr_rtb_name}#${propagation_name}" => {
        "transit_gateway_route_table_name" : tr_rtb_name,
        "attachment_name" : propagation_name
      }
    }
  ]])...)

  map_of_vpc_associations_to_list_of_static_routes = merge(flatten([[
    for tr_rtb_name, tr_rtb_spec in var.transit_route_tables_map : {
      for association_name in tr_rtb_spec["associations"] : association_name => flatten([
        for destination_name, routes in tr_rtb_spec["static_routes"] : routes if destination_name != "blackhole"
      ]) if contains(keys(var.vpc_attachments), association_name)
    }
  ]])...)

  map_of_vpc_associations_to_list_of_propagations_and_static_routes_cidrs = {
    for association_name in keys(var.vpc_attachments) : association_name => flatten([
      local.map_of_vpc_associations_to_list_of_static_routes[association_name],
      [for propagation_name in var.transit_route_tables_map[local.transposed_map_of_associations_from_var_transit_route_tables_map[association_name][0]]["propagations"] : data.aws_vpc.from_var_transit_route_tables_map[propagation_name].cidr_block if contains(keys(var.vpc_attachments), propagation_name)]
    ])
  }

  map_route_tables_ids_to_routes = merge(flatten([[
    for association_name in keys(var.vpc_attachments) : [
      for rtb_id in data.aws_route_tables.from_var_transit_route_tables_map[association_name].ids : {
        for cidr in local.map_of_vpc_associations_to_list_of_propagations_and_static_routes_cidrs[association_name] : "${association_name}#${rtb_id}#${cidr}" => {
          "route_table_id" : rtb_id,
          "destination_cidr_block" : cidr,
          "transit_gateway_id" : aws_ec2_transit_gateway.this[0].id
        }
      }
    ]
  ]])...)
}

resource "aws_ec2_transit_gateway" "this" {
  count = var.create_tgw ? 1 : 0

  description                     = coalesce(var.description, var.name)
  amazon_side_asn                 = var.amazon_side_asn
  default_route_table_association = var.enable_default_route_table_association ? "enable" : "disable"
  default_route_table_propagation = var.enable_default_route_table_propagation ? "enable" : "disable"
  auto_accept_shared_attachments  = var.enable_auto_accept_shared_attachments ? "enable" : "disable"
  vpn_ecmp_support                = var.enable_vpn_ecmp_support ? "enable" : "disable"
  dns_support                     = var.enable_dns_support ? "enable" : "disable"

  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags,
    var.tgw_tags,
  )
}

################
# Input testing
################
locals {
  has_error_in_uniqueness_of_vpn_vpc_names = length(setunion(keys(var.vpn_attachments), keys(var.vpc_attachments))) == length(keys(var.vpn_attachments)) + length(keys(var.vpc_attachments))

  has_error_of_vpc_attachments_with_routes_while_using_transit_route_tables_map = length(local.vpc_attachments_with_routes) > 0 && var.transit_route_tables_map != {}

  has_error_of_correctness_of_transit_route_tables_map_static_routes = length(compact(flatten([for k, v in local.transposed_map_of_routes_from_var_transit_route_tables_map : v["has_error_in_static_routes_of_transit_route_table"]]))) > 0

  has_error_of_correctness_of_transit_route_tables_map_attachments_assignment_per_transit_gateway_route_table = length([for k, v in local.transposed_map_of_associations_from_var_transit_route_tables_map : k if length(v) != 1]) > 0
}

resource "null_resource" "check_uniqueness_of_vpn_vpc_names" {
  count = local.has_error_in_uniqueness_of_vpn_vpc_names ? 0 : "ERROR: Arbitrary names of VPN in var.vpn_attachments and arbitrary names of VPC attachments in var.vpc_attachments should be unique for both variables together."
}

resource "null_resource" "check_vpc_attachments_with_routes_while_using_transit_route_tables_map" {
  count = local.has_error_of_vpc_attachments_with_routes_while_using_transit_route_tables_map ? "ERROR: There is no possibility to use both var.vpc_attachments with routes and non-empty var.transit_route_tables_map." : 0
}

resource "null_resource" "check_correctness_of_transit_route_tables_map_static_routes" {
  count = local.has_error_of_correctness_of_transit_route_tables_map_static_routes ? "ERROR: There is error in var.transit_route_tables_map static_routes. Static routes in the same route table should be unique" : 0
}

resource "null_resource" "check_correctness_of_transit_route_tables_map_attachments_assignment_per_transit_gateway_route_table" {
  count = local.has_error_of_correctness_of_transit_route_tables_map_attachments_assignment_per_transit_gateway_route_table ? "ERROR: There is error assignment of the same attachment to different transit route tables or not assigning some attachment to any transit route table" : 0
}

######################################################################################
# Transit Gateway Route table and routes created using var.vpc_attachments with routes
######################################################################################
resource "aws_ec2_transit_gateway_route_table" "this" {
  count = var.create_tgw && var.transit_route_tables_map == {} ? 1 : 0

  transit_gateway_id = aws_ec2_transit_gateway.this[0].id

  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags,
    var.tgw_route_table_tags,
  )
}

// VPC attachment routes
resource "aws_ec2_transit_gateway_route" "this" {
  count = var.transit_route_tables_map != {} ? 0 : length(local.vpc_attachments_with_routes)

  destination_cidr_block = local.vpc_attachments_with_routes[count.index][1]["destination_cidr_block"]
  blackhole              = lookup(local.vpc_attachments_with_routes[count.index][1], "blackhole", null)

  transit_gateway_route_table_id = var.create_tgw ? aws_ec2_transit_gateway_route_table.this[0].id : var.transit_gateway_route_table_id
  transit_gateway_attachment_id  = tobool(lookup(local.vpc_attachments_with_routes[count.index][1], "blackhole", false)) == false ? aws_ec2_transit_gateway_vpc_attachment.this[local.vpc_attachments_with_routes[count.index][0]["key"]].id : null
}

###########################################################################
# Transit Route table and routes created using var.transit_route_tables_map
###########################################################################
resource "aws_ec2_transit_gateway_route_table" "from_var_transit_route_tables_map" {
  for_each = var.create_tgw ? var.transit_route_tables_map : {}

  transit_gateway_id = aws_ec2_transit_gateway.this[0].id

  tags = merge(
    {
      "Name" = "${var.name}-${each.key}"
    },
    var.tags,
    var.tgw_route_table_tags,
  )
}

// Routes via var.transit_route_tables_map
resource "aws_ec2_transit_gateway_route" "from_var_transit_route_tables_map" {
  for_each = var.create_tgw ? local.transposed_map_of_routes_from_var_transit_route_tables_map : {}

  destination_cidr_block = each.value.destination_cidr_block
  blackhole              = each.value.attachment_name == "blackhole" ? true : false

  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.from_var_transit_route_tables_map[each.value.transit_gateway_route_table_name].id
  transit_gateway_attachment_id  = each.value.attachment_name != "blackhole" ? local.map_of_logical_names_vpn_and_vpc_to_attachments_ids[each.value.attachment_name] : null
}

##############################################################################
# VPC,VPN Attachments, transit gateway route table association and propagation
##############################################################################
resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  for_each = var.vpc_attachments

  transit_gateway_id = lookup(each.value, "tgw_id", aws_ec2_transit_gateway.this[0].id)
  vpc_id             = each.value.vpc_id
  subnet_ids         = each.value.subnet_ids

  dns_support                                     = lookup(each.value, "dns_support", true) ? "enable" : "disable"
  ipv6_support                                    = lookup(each.value, "ipv6_support", false) ? "enable" : "disable"
  transit_gateway_default_route_table_association = lookup(each.value, "transit_gateway_default_route_table_association", true)
  transit_gateway_default_route_table_propagation = lookup(each.value, "transit_gateway_default_route_table_propagation", true)

  tags = merge(
    {
      Name = format("%s-%s", var.name, each.key)
    },
    var.tags,
    var.tgw_vpc_attachment_tags,
  )
}

resource "aws_ec2_transit_gateway_route_table_association" "this" {
  for_each = var.transit_route_tables_map != {} ? {} : local.vpc_attachments_without_default_route_table_association

  // Create association if it was not set already by aws_ec2_transit_gateway_vpc_attachment resource
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.this[each.key].id
  transit_gateway_route_table_id = coalesce(lookup(each.value, "transit_gateway_route_table_id", null), var.transit_gateway_route_table_id, aws_ec2_transit_gateway_route_table.this[0].id)
}

resource "aws_ec2_transit_gateway_route_table_propagation" "this" {
  for_each = var.transit_route_tables_map != {} ? {} : local.vpc_attachments_without_default_route_table_association

  // Create association if it was not set already by aws_ec2_transit_gateway_vpc_attachment resource
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.this[each.key].id
  transit_gateway_route_table_id = coalesce(lookup(each.value, "transit_gateway_route_table_id", null), var.transit_gateway_route_table_id, aws_ec2_transit_gateway_route_table.this[0].id)
}

data "aws_ec2_transit_gateway_vpn_attachment" "this" {
  for_each           = var.vpn_attachments
  transit_gateway_id = lookup(each.value, "tgw_id", aws_ec2_transit_gateway.this[0].id)
  vpn_connection_id  = each.value.vpn_id
}

############################################################################################
# Transit Gateway route table association and propagation using var.transit_route_tables_map
############################################################################################

resource "aws_ec2_transit_gateway_route_table_association" "from_var_transit_route_tables_map" {
  for_each = var.create_tgw ? local.transposed_map_of_associations_from_var_transit_route_tables_map : {}

  transit_gateway_attachment_id  = local.map_of_logical_names_vpn_and_vpc_to_attachments_ids[each.key]
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.from_var_transit_route_tables_map[each.value[0]].id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "from_var_transit_route_tables_map" {
  for_each = var.create_tgw ? local.map_of_propagations_from_var_transit_route_tables_map : {}

  transit_gateway_attachment_id  = local.map_of_logical_names_vpn_and_vpc_to_attachments_ids[each.value.attachment_name]
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.from_var_transit_route_tables_map[each.value.transit_gateway_route_table_name].id
}
##################################################################
# VPC route table routes update using var.transit_route_tables_map
##################################################################

data aws_vpc from_var_transit_route_tables_map {
  for_each = var.vpc_attachments
  id       = each.value.vpc_id
}

data aws_route_tables from_var_transit_route_tables_map {
  for_each = var.vpc_attachments
  vpc_id   = each.value.vpc_id

  dynamic filter {
    for_each = var.enable_tgw_connectivity_in_vpc_route_tables_by_tags
    content {
      name   = "tag:${filter.key}"
      values = [filter.value]
    }
  }
}

resource "aws_route" "from_var_transit_route_tables_map" {
  for_each               = local.map_route_tables_ids_to_routes
  route_table_id         = each.value.route_table_id
  destination_cidr_block = each.value.destination_cidr_block
  transit_gateway_id     = each.value.transit_gateway_id
}

##########################
# Resource Access Manager
##########################
resource "aws_ram_resource_share" "this" {
  count = var.create_tgw && var.share_tgw ? 1 : 0

  name                      = coalesce(var.ram_name, var.name)
  allow_external_principals = var.ram_allow_external_principals

  tags = merge(
    {
      "Name" = format("%s", coalesce(var.ram_name, var.name))
    },
    var.tags,
    var.ram_tags,
  )
}

resource "aws_ram_resource_association" "this" {
  count = var.create_tgw && var.share_tgw ? 1 : 0

  resource_arn       = aws_ec2_transit_gateway.this[0].arn
  resource_share_arn = aws_ram_resource_share.this[0].id
}

resource "aws_ram_principal_association" "this" {
  count = var.create_tgw && var.share_tgw ? length(var.ram_principals) : 0

  principal          = var.ram_principals[count.index]
  resource_share_arn = aws_ram_resource_share.this[0].arn
}
