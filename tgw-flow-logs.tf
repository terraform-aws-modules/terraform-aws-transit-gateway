locals {
  enable_flow_log = var.create_tgw && var.enable_flow_log

  create_flow_log_cloudwatch_iam_role  = local.enable_flow_log && var.flow_log_destination_type == "cloud-watch-logs" && var.create_flow_log_cloudwatch_iam_role
  create_flow_log_cloudwatch_log_group = local.enable_flow_log && var.flow_log_destination_type == "cloud-watch-logs" && var.create_flow_log_cloudwatch_log_group

  flow_log_destination_arn                  = local.create_flow_log_cloudwatch_log_group ? try(aws_cloudwatch_log_group.flow_log[0].arn, null) : try(coalesce(var.flow_log_destination_arn), null)
  flow_log_iam_role_arn                     = local.create_flow_log_cloudwatch_iam_role ? try(aws_iam_role.tgw_flow_log_cloudwatch[0].arn, null) : try(coalesce(var.flow_log_cloudwatch_iam_role_arn), null)
  flow_log_cloudwatch_log_group_name_suffix = var.flow_log_cloudwatch_log_group_name_suffix == "" ? try(aws_ec2_transit_gateway.this[0].id, "") : var.flow_log_cloudwatch_log_group_name_suffix
}

################################################################################
# Flow Log
################################################################################

resource "aws_flow_log" "this" {
  count = local.enable_flow_log ? 1 : 0

  region = var.region

  transit_gateway_id         = aws_ec2_transit_gateway.this[0].id
  log_destination_type       = var.flow_log_destination_type
  log_destination            = local.flow_log_destination_arn
  log_format                 = var.flow_log_log_format
  iam_role_arn               = local.flow_log_iam_role_arn
  deliver_cross_account_role = var.flow_log_deliver_cross_account_role

  # Transit Gateway flow logs only support a 60 second aggregation interval and do not accept `traffic_type`
  max_aggregation_interval = 60

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
    { Name = var.name },
    var.tgw_flow_log_tags,
  )
}

################################################################################
# Flow Log CloudWatch
################################################################################

resource "aws_cloudwatch_log_group" "flow_log" {
  count = local.create_flow_log_cloudwatch_log_group ? 1 : 0

  region = var.region

  name              = "${var.flow_log_cloudwatch_log_group_name_prefix}${local.flow_log_cloudwatch_log_group_name_suffix}"
  retention_in_days = var.flow_log_cloudwatch_log_group_retention_in_days
  kms_key_id        = var.flow_log_cloudwatch_log_group_kms_key_id
  skip_destroy      = var.flow_log_cloudwatch_log_group_skip_destroy
  log_group_class   = var.flow_log_cloudwatch_log_group_class

  tags = merge(var.tags, var.tgw_flow_log_tags)
}

resource "aws_iam_role" "tgw_flow_log_cloudwatch" {
  count = local.create_flow_log_cloudwatch_iam_role ? 1 : 0

  name        = var.tgw_flow_log_iam_role_use_name_prefix ? null : var.tgw_flow_log_iam_role_name
  name_prefix = var.tgw_flow_log_iam_role_use_name_prefix ? "${var.tgw_flow_log_iam_role_name}-" : null
  path        = var.tgw_flow_log_iam_role_path

  assume_role_policy   = data.aws_iam_policy_document.flow_log_cloudwatch_assume_role[0].json
  permissions_boundary = var.tgw_flow_log_permissions_boundary

  tags = merge(var.tags, var.tgw_flow_log_tags)
}

data "aws_iam_policy_document" "flow_log_cloudwatch_assume_role" {
  count = local.create_flow_log_cloudwatch_iam_role ? 1 : 0

  statement {
    sid = "AWSVPCFlowLogsAssumeRole"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    effect = "Allow"

    actions = ["sts:AssumeRole"]

    dynamic "condition" {
      for_each = var.flow_log_cloudwatch_iam_role_conditions
      content {
        test     = condition.value.test
        variable = condition.value.variable
        values   = condition.value.values
      }
    }
  }
}

resource "aws_iam_role_policy_attachment" "tgw_flow_log_cloudwatch" {
  count = local.create_flow_log_cloudwatch_iam_role ? 1 : 0

  role       = aws_iam_role.tgw_flow_log_cloudwatch[0].name
  policy_arn = aws_iam_policy.tgw_flow_log_cloudwatch[0].arn
}

resource "aws_iam_policy" "tgw_flow_log_cloudwatch" {
  count = local.create_flow_log_cloudwatch_iam_role ? 1 : 0

  name        = var.tgw_flow_log_iam_policy_use_name_prefix ? null : var.tgw_flow_log_iam_policy_name
  name_prefix = var.tgw_flow_log_iam_policy_use_name_prefix ? "${var.tgw_flow_log_iam_policy_name}-" : null
  policy      = data.aws_iam_policy_document.tgw_flow_log_cloudwatch[0].json

  tags = merge(var.tags, var.tgw_flow_log_tags)
}

data "aws_iam_policy_document" "tgw_flow_log_cloudwatch" {
  count = local.create_flow_log_cloudwatch_iam_role ? 1 : 0

  statement {
    sid = "AWSTGWFlowLogsPushToCloudWatch"

    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = ["${local.flow_log_destination_arn}:*"]
  }
}
