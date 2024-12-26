provider "aws" {
  region = local.region
}

data "aws_caller_identity" "current" {}

locals {
  name   = "ex-tgw-${basename(path.cwd)}"
  region = "eu-west-1"

  account_id = data.aws_caller_identity.current.account_id

  tags = {
    Example    = local.name
    GithubRepo = "terraform-aws-transit-gateway"
  }
}

################################################################################
# Transit Gateway Module
################################################################################

module "tgw" {
  source = "../../"

  name                        = local.name
  description                 = "Example TGW connecting multiple VPCs"
  amazon_side_asn             = 64532
  transit_gateway_cidr_blocks = ["10.99.0.0/24"]

  # flow_logs = {
  #   tgw = {
  #     log_destination      = module.s3_bucket.s3_bucket_arn
  #     log_destination_type = "s3"
  #     traffic_type         = "ALL"
  #     destination_options = {
  #       file_format        = "parquet"
  #       per_hour_partition = true
  #     }
  #   }
  #   vpc1-attach = {
  #     log_destination      = module.s3_bucket.s3_bucket_arn
  #     log_destination_type = "s3"
  #     traffic_type         = "ALL"
  #     destination_options = {
  #       file_format        = "parquet"
  #       per_hour_partition = true
  #     }
  #   }
  #   vpc2-attach = {
  #     log_destination      = module.s3_bucket.s3_bucket_arn
  #     log_destination_type = "s3"
  #     traffic_type         = "ALL"
  #     destination_options = {
  #       file_format        = "parquet"
  #       per_hour_partition = true
  #     }
  #   }
  # }

  vpc_attachments = {
    vpc1 = {
      vpc_id       = module.vpc1.vpc_id
      subnet_ids   = module.vpc1.private_subnets
      ipv6_support = true
    }

    vpc2 = {
      vpc_id     = module.vpc2.vpc_id
      subnet_ids = module.vpc2.private_subnets
    }
  }

  tags = local.tags
}

module "transit_gateway_route_table" {
  source = "../../modules/route-table"

  name               = local.name
  transit_gateway_id = module.tgw.id

  associations = {
    vpc1 = {
      transit_gateway_attachment_id = module.tgw.vpc_attachments["vpc1"].id
      propagate_route_table         = true
    }
    vpc2 = {
      transit_gateway_attachment_id = module.tgw.vpc_attachments["vpc2"].id
      propagate_route_table         = true
    }
  }

  routes = {
    blackhole = {
      blackhole              = true
      destination_cidr_block = "0.0.0.0/0"
    }
  }

  tags = local.tags
}

################################################################################
# Supporting resources
################################################################################

locals {
  vpc1_cidr = "10.0.0.0/16"
  vpc2_cidr = "10.20.0.0/16"
  azs       = slice(data.aws_availability_zones.available.names, 0, 3)
}

data "aws_availability_zones" "available" {
  # Exclude local zones
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

module "vpc1" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${local.name}-vpc1"
  cidr = local.vpc1_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc1_cidr, 4, k)]

  enable_ipv6                                    = true
  private_subnet_assign_ipv6_address_on_creation = true
  private_subnet_ipv6_prefixes                   = [0, 1, 2]

  tags = local.tags
}

module "vpc2" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${local.name}-vpc2"
  cidr = local.vpc2_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc2_cidr, 4, k)]

  tags = local.tags
}

resource "random_pet" "this" {
  length = 2
}

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.0"

  bucket        = "${local.name}-${random_pet.this.id}"
  policy        = data.aws_iam_policy_document.flow_log_s3.json
  force_destroy = true

  tags = local.tags
}

data "aws_iam_policy_document" "flow_log_s3" {
  statement {
    sid = "AWSLogDeliveryWrite"

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${local.name}-${random_pet.this.id}/*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [local.account_id]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:logs:${local.region}:${local.account_id}:*"]
    }
  }

  statement {
    sid = "AWSLogDeliveryAclCheck"

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    actions = [
      "s3:Get*",
      "s3:List*",
    ]
    resources = ["arn:aws:s3:::${local.name}-${random_pet.this.id}"]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [local.account_id]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:logs:${local.region}:${local.account_id}:*"]
    }
  }
}
