provider "aws" {
  region = local.region
}

data "aws_caller_identity" "current" {}

locals {
  region = "eu-west-1"
  name   = "ex-${basename(path.cwd)}"

  tags = {
    Name       = local.name
    Example    = local.name
    Repository = "https://github.com/terraform-aws-modules/terraform-aws-transit-gateway"
  }
}

################################################################################
# Transit Gateway Module - Flow Log to CloudWatch
################################################################################

module "tgw_flow_log_cloudwatch" {
  source = "../../"

  name        = "${local.name}-cloudwatch"
  description = "TGW with flow logs delivered to CloudWatch Logs"

  share_tgw = false

  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true

  flow_log_destination_type                       = "cloud-watch-logs"
  flow_log_log_format                             = "$${version} $${resource-type} $${account-id} $${tgw-id} $${tgw-attachment-id} $${srcaddr} $${dstaddr} $${srcport} $${dstport} $${protocol} $${packets} $${bytes} $${start} $${end} $${log-status}"
  flow_log_cloudwatch_log_group_retention_in_days = 7

  flow_log_cloudwatch_iam_role_conditions = [
    {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    },
  ]

  tgw_flow_log_iam_role_name   = "${local.name}-flow-log"
  tgw_flow_log_iam_policy_name = "${local.name}-flow-log"
  tgw_flow_log_tags            = { Destination = "cloud-watch-logs" }

  tags = local.tags
}

################################################################################
# Transit Gateway Module - Flow Log to S3
################################################################################

module "tgw_flow_log_s3" {
  source = "../../"

  name        = "${local.name}-s3"
  description = "TGW with flow logs delivered to S3"

  share_tgw = false

  enable_flow_log           = true
  flow_log_destination_type = "s3"
  flow_log_destination_arn  = module.s3_bucket.s3_bucket_arn

  flow_log_file_format                = "parquet"
  flow_log_hive_compatible_partitions = true
  flow_log_per_hour_partition         = true

  tgw_flow_log_tags = { Destination = "s3" }

  tags = local.tags
}

################################################################################
# Supporting resources
################################################################################

# Flow log delivery writes under `AWSLogs/aws-account-id=<id>/` when hive compatible partitions
# are enabled, so both prefixes are granted up front to avoid a permanent diff on the bucket policy
module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 5.0"

  bucket_prefix = "${local.name}-"
  force_destroy = true

  attach_policy = true
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AWSLogDeliveryAclCheck"
        Effect    = "Allow"
        Principal = { Service = "delivery.logs.amazonaws.com" }
        Action    = "s3:GetBucketAcl"
        Resource  = "_S3_BUCKET_ARN_"
        Condition = {
          StringEquals = { "aws:SourceAccount" = data.aws_caller_identity.current.account_id }
          ArnLike      = { "aws:SourceArn" = "arn:aws:logs:${local.region}:${data.aws_caller_identity.current.account_id}:*" }
        }
      },
      {
        Sid       = "AWSLogDeliveryWrite"
        Effect    = "Allow"
        Principal = { Service = "delivery.logs.amazonaws.com" }
        Action    = "s3:PutObject"
        Resource = [
          "_S3_BUCKET_ARN_/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
          "_S3_BUCKET_ARN_/AWSLogs/aws-account-id=${data.aws_caller_identity.current.account_id}/*",
        ]
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
            "s3:x-amz-acl"      = "bucket-owner-full-control"
          }
          ArnLike = { "aws:SourceArn" = "arn:aws:logs:${local.region}:${data.aws_caller_identity.current.account_id}:*" }
        }
      },
    ]
  })

  tags = local.tags
}
