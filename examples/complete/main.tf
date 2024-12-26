provider "aws" {
  region = local.region
}

locals {
  name   = "ex-tgw-${replace(basename(path.cwd), "_", "-")}"
  region = "eu-west-1"

  account_id = "012345678901"

  flow_logs_cloudwatch_dest_arn     = "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/tgw/"
  flow_logs_cloudwatch_iam_role_arn = "arn:aws:iam::${local.account_id}:role/tgw-flow-logs-to-cloudwatch"
  flow_logs_s3_dest_arn             = "arn:aws:s3:::tgw-flow-logs-${local.account_id}-${local.region}"

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

  name            = local.name
  description     = "My TGW connecting multiple VPCs"
  amazon_side_asn = 64532

  # Creates RAM resources for hub (create_tgw = true) accounts
  share_tgw = false

  transit_gateway_cidr_blocks = ["10.99.0.0/24"]

  # When "true" there is no need for RAM resources if using multiple AWS accounts
  enable_auto_accept_shared_attachments = false

  enable_default_route_table_association = false
  enable_default_route_table_propagation = false

  # When "true", allows service discovery through IGMP
  enable_multicast_support = false

  flow_logs = [
    # Flow logs for the entire TGW
    {
      cloudwatch_dest_arn     = local.flow_logs_cloudwatch_dest_arn
      cloudwatch_iam_role_arn = local.flow_logs_cloudwatch_iam_role_arn
      dest_enabled            = true
      dest_type               = "cloud-watch-logs"
      key                     = "tgw"
      s3_dest_arn             = null
    },
    {
      cloudwatch_dest_arn     = null
      cloudwatch_iam_role_arn = null
      dest_enabled            = true
      dest_type               = "s3"
      key                     = "tgw"
      s3_dest_arn             = local.flow_logs_s3_dest_arn
    },
    # Flow logs for individual attachments
    {
      attachment_type         = "vpc"
      cloudwatch_dest_arn     = local.flow_logs_cloudwatch_dest_arn
      cloudwatch_iam_role_arn = local.flow_logs_cloudwatch_iam_role_arn
      create_tgw_peering      = false
      create_vpc_attachment   = true
      dest_enabled            = true
      dest_type               = "cloud-watch-logs"
      key                     = "vpc1"
      s3_dest_arn             = null
    },
    {
      attachment_type         = "vpc"
      cloudwatch_dest_arn     = null
      cloudwatch_iam_role_arn = null
      create_tgw_peering      = false
      create_vpc_attachment   = true
      dest_enabled            = true
      dest_type               = "s3"
      key                     = "vpc1"
      s3_dest_arn             = local.flow_logs_s3_dest_arn
    },
    {
      attachment_type         = "vpc"
      cloudwatch_dest_arn     = local.flow_logs_cloudwatch_dest_arn
      cloudwatch_iam_role_arn = local.flow_logs_cloudwatch_iam_role_arn
      create_tgw_peering      = false
      create_vpc_attachment   = true
      dest_enabled            = true
      dest_type               = "cloud-watch-logs"
      key                     = "vpc2"
      s3_dest_arn             = null
    },
    {
      attachment_type         = "vpc"
      cloudwatch_dest_arn     = null
      cloudwatch_iam_role_arn = null
      create_tgw_peering      = false
      create_vpc_attachment   = true
      dest_enabled            = true
      dest_type               = "s3"
      key                     = "vpc2"
      s3_dest_arn             = local.flow_logs_s3_dest_arn
    },
  ]

  attachments = {
    vpc1 = {
      attachment_type       = "vpc"
      create_vpc_attachment = true
      # Keep enable_vpc_attachment = false until the corresponding VPC attachment is created/accepted
      enable_vpc_attachment                           = false
      vpc_id                                          = module.vpc1.vpc_id
      subnet_ids                                      = module.vpc1.private_subnets
      transit_gateway_default_route_table_association = false
      transit_gateway_default_route_table_propagation = false
      dns_support                                     = true
      ipv6_support                                    = true
      # Keep create_tgw_routes = false until the VPC/peering attachments exist/are accepted
      create_tgw_routes = true
      tgw_route_table_propagations = {
        prod = {
          enable = true
        },
        staging = {
          enable = true
        }
      }
      tgw_routes = {
        vpc1 = {
          destination_cidr_blocks = module.vpc1.private_subnets_cidr_blocks
          route_table             = "prod"
        }
        blackhole = {
          blackhole               = true
          destination_cidr_blocks = ["0.0.0.0/0"]
          route_table             = "prod"
        }
      }
    }
    vpc2 = {
      attachment_type       = "vpc"
      create_vpc_attachment = true
      # Keep enable_vpc_attachment = false until the corresponding VPC attachment is created/accepted
      enable_vpc_attachment                           = false
      vpc_id                                          = module.vpc2.vpc_id
      subnet_ids                                      = module.vpc2.private_subnets
      transit_gateway_default_route_table_association = false
      transit_gateway_default_route_table_propagation = false
      dns_support                                     = true
      ipv6_support                                    = false
      # Keep create_tgw_routes = false until the VPC/peering attachments exist/are accepted
      create_tgw_routes = true
      tgw_route_table_propagations = {
        prod = {
          enable = true
        },
        staging = {
          enable = true
        }
      }
      tgw_routes = {
        vpc2 = {
          destination_cidr_blocks = module.vpc2.private_subnets_cidr_blocks
          route_table             = "prod"
        }
        blackhole = {
          blackhole               = true
          destination_cidr_blocks = ["0.0.0.0/0"]
          route_table             = "prod"
        }
      }

      tags = {
        Name = "${local.name}-vpc2"
      }

    }
  }

  ram_allow_external_principals = false
  ram_principals = [
    local.account_id
  ]

  tags = local.tags
}

################################################################################
# Supporting resources
################################################################################

module "vpc1" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${local.name}-vpc1"
  cidr = "10.10.0.0/16"

  azs             = ["${local.region}a", "${local.region}b", "${local.region}c"]
  private_subnets = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]

  enable_ipv6                                    = true
  private_subnet_assign_ipv6_address_on_creation = true
  private_subnet_ipv6_prefixes                   = [0, 1, 2]

  tags = local.tags
}

module "vpc2" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${local.name}-vpc2"
  cidr = "10.20.0.0/16"

  azs             = ["${local.region}a", "${local.region}b", "${local.region}c"]
  private_subnets = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24"]

  tags = local.tags
}
