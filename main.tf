locals {
  # Only create flow log if user selected to create a Transit Gateway as well.
  enable_flow_log = var.create_tgw && var.enable_flow_log

  create_flow_log_cloudwatch_iam_role  = local.enable_flow_log && var.flow_log_destination_type != "s3" && var.create_flow_log_cloudwatch_iam_role
  create_flow_log_cloudwatch_log_group = local.enable_flow_log && var.flow_log_destination_type != "s3" && var.create_flow_log_cloudwatch_log_group

  flow_log_destination_arn = local.create_flow_log_cloudwatch_log_group ? aws_cloudwatch_log_group.tgw_flow_log[0].arn : var.flow_log_destination_arn
  flow_log_iam_role_arn    = var.flow_log_destination_type != "s3" && local.create_flow_log_cloudwatch_iam_role ? aws_iam_role.tgw_flow_log_cloudwatch[0].arn : var.flow_log_cloudwatch_iam_role_arn

  # List of maps with key and route values
  vpc_attachments_with_routes = chunklist(flatten([
    for k, v in var.vpc_attachments : setproduct([{ key = k }], v.tgw_routes) if var.create_tgw && can(v.tgw_routes)
  ]), 2)

  tgw_default_route_table_tags_merged = merge(
    var.tags,
    { Name = var.name },
    var.tgw_default_route_table_tags,
  )

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
# Transit Gateway
################################################################################

resource "aws_ec2_transit_gateway" "this" {
  count = var.create_tgw ? 1 : 0

  description                     = coalesce(var.description, var.name)
  amazon_side_asn                 = var.amazon_side_asn
  default_route_table_association = var.enable_default_route_table_association ? "enable" : "disable"
  default_route_table_propagation = var.enable_default_route_table_propagation ? "enable" : "disable"
  auto_accept_shared_attachments  = var.enable_auto_accept_shared_attachments ? "enable" : "disable"
  multicast_support               = var.enable_mutlicast_support ? "enable" : "disable"
  vpn_ecmp_support                = var.enable_vpn_ecmp_support ? "enable" : "disable"
  dns_support                     = var.enable_dns_support ? "enable" : "disable"
  transit_gateway_cidr_blocks     = var.transit_gateway_cidr_blocks

  timeouts {
    create = try(var.timeouts.create, null)
    update = try(var.timeouts.update, null)
    delete = try(var.timeouts.delete, null)
  }

  tags = merge(
    var.tags,
    { Name = var.name },
    var.tgw_tags,
  )
}

resource "aws_ec2_tag" "this" {
  for_each = { for k, v in local.tgw_default_route_table_tags_merged : k => v if var.create_tgw && var.enable_default_route_table_association }

  resource_id = aws_ec2_transit_gateway.this[0].association_default_route_table_id
  key         = each.key
  value       = each.value
}

################################################################################
# VPC Attachment
################################################################################

resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  for_each = var.vpc_attachments

  transit_gateway_id = var.create_tgw ? aws_ec2_transit_gateway.this[0].id : each.value.tgw_id
  vpc_id             = each.value.vpc_id
  subnet_ids         = each.value.subnet_ids

  dns_support                                     = try(each.value.dns_support, true) ? "enable" : "disable"
  ipv6_support                                    = try(each.value.ipv6_support, false) ? "enable" : "disable"
  appliance_mode_support                          = try(each.value.appliance_mode_support, false) ? "enable" : "disable"
  transit_gateway_default_route_table_association = try(each.value.transit_gateway_default_route_table_association, true)
  transit_gateway_default_route_table_propagation = try(each.value.transit_gateway_default_route_table_propagation, true)

  tags = merge(
    var.tags,
    { Name = var.name },
    var.tgw_vpc_attachment_tags,
  )
}

################################################################################
# Route Table / Routes
################################################################################

resource "aws_ec2_transit_gateway_route_table" "this" {
  count = var.create_tgw ? 1 : 0

  transit_gateway_id = aws_ec2_transit_gateway.this[0].id

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

  transit_gateway_route_table_id = var.create_tgw ? aws_ec2_transit_gateway_route_table.this[0].id : var.transit_gateway_route_table_id
  transit_gateway_attachment_id  = tobool(try(local.vpc_attachments_with_routes[count.index][1].blackhole, false)) == false ? aws_ec2_transit_gateway_vpc_attachment.this[local.vpc_attachments_with_routes[count.index][0].key].id : null
}

resource "aws_route" "this" {
  for_each = { for x in local.vpc_route_table_destination_cidr : x.rtb_id => x.cidr }

  route_table_id         = each.key
  destination_cidr_block = each.value
  transit_gateway_id     = aws_ec2_transit_gateway.this[0].id
}

resource "aws_ec2_transit_gateway_route_table_association" "this" {
  for_each = {
    for k, v in var.vpc_attachments : k => v if var.create_tgw && try(v.transit_gateway_default_route_table_association, true) != true
  }

  # Create association if it was not set already by aws_ec2_transit_gateway_vpc_attachment resource
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.this[each.key].id
  transit_gateway_route_table_id = var.create_tgw ? aws_ec2_transit_gateway_route_table.this[0].id : try(each.value.transit_gateway_route_table_id, var.transit_gateway_route_table_id)
}

resource "aws_ec2_transit_gateway_route_table_propagation" "this" {
  for_each = {
    for k, v in var.vpc_attachments : k => v if var.create_tgw && try(v.transit_gateway_default_route_table_propagation, true) != true
  }

  # Create association if it was not set already by aws_ec2_transit_gateway_vpc_attachment resource
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.this[each.key].id
  transit_gateway_route_table_id = var.create_tgw ? aws_ec2_transit_gateway_route_table.this[0].id : try(each.value.transit_gateway_route_table_id, var.transit_gateway_route_table_id)
}

################################################################################
# Resource Access Manager
################################################################################

resource "aws_ram_resource_share" "this" {
  count = var.create_tgw && var.share_tgw ? 1 : 0

  name                      = coalesce(var.ram_name, var.name)
  allow_external_principals = var.ram_allow_external_principals

  tags = merge(
    var.tags,
    { Name = coalesce(var.ram_name, var.name) },
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

resource "aws_ram_resource_share_accepter" "this" {
  count = !var.create_tgw && var.share_tgw ? 1 : 0

  share_arn = var.ram_resource_share_arn
}

################################################################################
# Flow Log
################################################################################
resource "aws_flow_log" "this" {
  count = local.enable_flow_log ? 1 : 0

  log_destination      = local.flow_log_destination_arn
  log_destination_type = var.flow_log_destination_type
  log_format           = var.flow_log_log_format
  iam_role_arn         = local.flow_log_iam_role_arn
  traffic_type         = var.flow_log_traffic_type
  transit_gateway_id   = aws_ec2_transit_gateway.this[0].id

  dynamic "destination_options" {
    for_each = var.flow_log_destination_type == "s3" ? [true] : []

    content {
      file_format                = var.flow_log_file_format
      hive_compatible_partitions = var.flow_log_hive_compatible_partitions
      per_hour_partition         = var.flow_log_per_hour_partition
    }
  }

  tags = merge(
    var.tags,
    var.flow_log_tags
  )
}

################################################################################
# Flow Log CloudWatch
################################################################################
resource "aws_cloudwatch_log_group" "tgw_flow_log" {
  count = local.create_flow_log_cloudwatch_log_group ? 1 : 0

  name              = "${var.flow_log_cloudwatch_log_group_name_prefix}${aws_ec2_transit_gateway.this[0].id}"
  retention_in_days = var.flow_log_cloudwatch_log_group_retention_in_days
  kms_key_id        = var.flow_log_cloudwatch_log_group_kms_key_id

  tags = merge(
    var.tags,
    var.flow_log_tags
  )
}

resource "aws_iam_role" "tgw_flow_log_cloudwatch" {
  count = local.create_flow_log_cloudwatch_iam_role ? 1 : 0

  name_prefix          = "tgw-flow-log-role-"
  assume_role_policy   = data.aws_iam_policy_document.tgw_flow_log_cloudwatch_assume_role[0].json
  permissions_boundary = var.flow_log_cloudwatch_iam_role_permissions_boundary

  tags = merge(
    var.tags,
    var.flow_log_tags
  )
}

data "aws_iam_policy_document" "tgw_flow_log_cloudwatch_assume_role" {
  count = local.create_flow_log_cloudwatch_iam_role ? 1 : 0

  statement {
    sid = "AWSVPCFlowLogsAssumeRole"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    effect = "Allow"

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_policy" "tgw_flow_log_cloudwatch" {
  count = local.create_flow_log_cloudwatch_iam_role ? 1 : 0

  name_prefix = "tgw-flow-log-to-cloudwatch-"
  policy      = data.aws_iam_policy_document.tgw_flow_log_cloudwatch[0].json

  tags = merge(
    var.tags,
    var.flow_log_tags
  )
}

data "aws_iam_policy_document" "tgw_flow_log_cloudwatch" {
  count = local.create_flow_log_cloudwatch_iam_role ? 1 : 0

  statement {
    sid = "AWSVPCFlowLogsPushToCloudWatch"

    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy_attachment" "tgw_flow_log_cloudwatch" {
  count = local.create_flow_log_cloudwatch_iam_role ? 1 : 0

  role       = aws_iam_role.tgw_flow_log_cloudwatch[0].name
  policy_arn = aws_iam_policy.tgw_flow_log_cloudwatch[0].arn
}
