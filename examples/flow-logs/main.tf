provider "aws" {
  region = local.region
}

locals {
  name   = "ex-tgw-flow-logs-${replace(basename(path.cwd), "_", "-")}"
  region = "eu-west-1"

  tags = {
    Example    = local.name
    GithubRepo = "terraform-aws-transit-gateway"
    GithubOrg  = "terraform-aws-modules"
  }
}

################################################################################
# Transit Gateway with CloudWatch Flow Logs
################################################################################

module "tgw_with_cloudwatch_logs" {
  source = "../../"

  name        = "${local.name}-cloudwatch"
  description = "TGW with CloudWatch flow logs"

  # Enable flow logs to CloudWatch
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true

  # CloudWatch log group settings
  flow_log_cloudwatch_log_group_name_prefix       = "/aws/transit-gateway/flowlogs/"
  flow_log_cloudwatch_log_group_retention_in_days = 30
  flow_log_cloudwatch_log_group_kms_key_id        = aws_kms_key.log_encryption.arn

  # Flow log settings
  flow_log_traffic_type             = "ALL"
  flow_log_max_aggregation_interval = 60
  flow_log_log_format               = "$${version} $${account-id} $${transit-gateway-id} $${transit-gateway-attachment-id} $${srcaddr} $${dstaddr} $${srcport} $${dstport} $${protocol} $${packets} $${bytes} $${windowstart} $${windowend} $${action}"

  vpc_attachments = {
    vpc1 = {
      vpc_id     = module.vpc1.vpc_id
      subnet_ids = module.vpc1.private_subnets
    }
    vpc2 = {
      vpc_id     = module.vpc2.vpc_id
      subnet_ids = module.vpc2.private_subnets
    }
  }

  tgw_flow_log_tags = {
    LogType     = "TransitGatewayFlow"
    Destination = "CloudWatch"
  }

  tags = local.tags
}

################################################################################
# Transit Gateway with S3 Flow Logs
################################################################################

module "tgw_with_s3_logs" {
  source = "../../"

  name        = "${local.name}-s3"
  description = "TGW with S3 flow logs"

  # Enable flow logs to S3
  enable_flow_log           = true
  flow_log_destination_type = "s3"
  flow_log_destination_arn  = aws_s3_bucket.flow_logs.arn

  # S3 destination options
  flow_log_file_format                = "parquet"
  flow_log_hive_compatible_partitions = true
  flow_log_per_hour_partition         = true

  # Flow log settings
  flow_log_traffic_type             = "ALL"
  flow_log_max_aggregation_interval = 600

  vpc_attachments = {
    vpc1 = {
      vpc_id     = module.vpc1.vpc_id
      subnet_ids = module.vpc1.private_subnets
    }
  }

  tgw_flow_log_tags = {
    LogType     = "TransitGatewayFlow"
    Destination = "S3"
  }

  tags = local.tags
}

################################################################################
# Transit Gateway with External Resources
################################################################################

module "tgw_with_external_resources" {
  source = "../../"

  name        = "${local.name}-external"
  description = "TGW with external flow log resources"

  # Enable flow logs using external resources
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = false
  create_flow_log_cloudwatch_iam_role  = false

  # Use external resources
  flow_log_destination_arn         = aws_cloudwatch_log_group.external.arn
  flow_log_cloudwatch_iam_role_arn = aws_iam_role.external.arn

  # Flow log settings
  flow_log_traffic_type             = "REJECT"
  flow_log_max_aggregation_interval = 60

  vpc_attachments = {
    vpc2 = {
      vpc_id     = module.vpc2.vpc_id
      subnet_ids = module.vpc2.private_subnets
    }
  }

  tgw_flow_log_tags = {
    LogType     = "TransitGatewayFlow"
    Destination = "CloudWatchExternal"
  }

  tags = local.tags
}

################################################################################
# Supporting Resources
################################################################################

# VPCs for demonstration
module "vpc1" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${local.name}-vpc1"
  cidr = "10.10.0.0/16"

  azs             = ["${local.region}a", "${local.region}b"]
  private_subnets = ["10.10.1.0/24", "10.10.2.0/24"]

  tags = local.tags
}

module "vpc2" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${local.name}-vpc2"
  cidr = "10.20.0.0/16"

  azs             = ["${local.region}a", "${local.region}b"]
  private_subnets = ["10.20.1.0/24", "10.20.2.0/24"]

  tags = local.tags
}

# KMS key for CloudWatch log encryption
resource "aws_kms_key" "log_encryption" {
  description = "KMS key for Transit Gateway flow logs encryption"

  tags = merge(local.tags, {
    Name = "${local.name}-log-encryption"
  })
}

resource "aws_kms_alias" "log_encryption" {
  name          = "alias/${local.name}-log-encryption"
  target_key_id = aws_kms_key.log_encryption.key_id
}

# S3 bucket for flow logs
resource "aws_s3_bucket" "flow_logs" {
  bucket        = "${local.name}-flow-logs-${random_id.bucket_suffix.hex}"
  force_destroy = true

  tags = merge(local.tags, {
    Name = "${local.name}-flow-logs"
  })
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket_policy" "flow_logs" {
  bucket = aws_s3_bucket.flow_logs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AWSLogDeliveryWrite"
        Effect = "Allow"
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.flow_logs.arn}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      },
      {
        Sid    = "AWSLogDeliveryAclCheck"
        Effect = "Allow"
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = aws_s3_bucket.flow_logs.arn
      }
    ]
  })
}

resource "aws_s3_bucket_versioning" "flow_logs" {
  bucket = aws_s3_bucket.flow_logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "flow_logs" {
  bucket = aws_s3_bucket.flow_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# External CloudWatch log group
resource "aws_cloudwatch_log_group" "external" {
  name              = "/aws/transit-gateway/external/${local.name}"
  retention_in_days = 7
  kms_key_id        = aws_kms_key.log_encryption.arn

  tags = merge(local.tags, {
    Name = "${local.name}-external-log-group"
  })
}

# External IAM role for flow logs
resource "aws_iam_role" "external" {
  name = "${local.name}-external-flow-log-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(local.tags, {
    Name = "${local.name}-external-flow-log-role"
  })
}

resource "aws_iam_role_policy" "external" {
  name = "${local.name}-external-flow-log-policy"
  role = aws_iam_role.external.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = "${aws_cloudwatch_log_group.external.arn}:*"
      }
    ]
  })
}
