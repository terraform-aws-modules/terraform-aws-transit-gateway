provider "aws" {
  region = "eu-west-1"
}

# This provider is required for attachment only installation in another AWS Account.
provider "aws" {
  region = "eu-west-1"
  alias  = "peer"
}

// See Notes in README.md for explanation regarding using data-sources and computed values
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "this" {
  vpc_id = data.aws_vpc.default.id
}

module "tgw" {
  source = "../../"

  name            = "my-tgw"
  description     = "My TGW shared with several other AWS accounts"
  amazon_side_asn = 64532

  enable_auto_accept_shared_attachments = true // When "true" there is no need for RAM resources if using multiple AWS accounts

  vpc_attachments = {
    vpc1 = {
      vpc_id                                          = data.aws_vpc.default.id      # module.vpc1.vpc_id
      subnet_ids                                      = data.aws_subnet_ids.this.ids # module.vpc1.private_subnets
      dns_support                                     = true
      ipv6_support                                    = true
      transit_gateway_default_route_table_association = false
      transit_gateway_default_route_table_propagation = false
      //      transit_gateway_route_table_id = "tgw-rtb-073a181ee589b360f"

      tgw_routes = [
        {
          destination_cidr_block = "30.0.0.0/16"
        },
        {
          blackhole              = true
          destination_cidr_block = "0.0.0.0/0"
        }
      ]
    },
    vpc2 = {
      vpc_id     = data.aws_vpc.default.id      # module.vpc2.vpc_id
      subnet_ids = data.aws_subnet_ids.this.ids # module.vpc2.private_subnets

      tgw_routes = [
        {
          destination_cidr_block = "50.0.0.0/16"
        },
        {
          blackhole              = true
          destination_cidr_block = "10.10.10.10/32"
        }
      ]
    },
  }

  ram_allow_external_principals = true
  ram_principals                = [307990089504]

  tags = {
    Purpose = "tgw-complete-example"
  }
}

module "tgw_peer" {
  # This is optional and connects to another account. Meaning you need to be authenticated with 2 separate AWS Accounts
  source = "../../"

  providers = {
    aws = aws.peer
  }

  name            = "my-tgw-peer"
  description     = "My TGW shared with several other AWS accounts"
  amazon_side_asn = 64532

  share_tgw                             = true
  create_tgw                            = false
  ram_resource_share_arn                = module.tgw.this_ram_resource_share_id
  enable_auto_accept_shared_attachments = true // When "true" there is no need for RAM resources if using multiple AWS accounts

  vpc_attachments = {
    vpc1 = {
      tgw_id                                          = module.tgw.this_ec2_transit_gateway_id
      vpc_id                                          = data.aws_vpc.default.id      # module.vpc1.vpc_id
      subnet_ids                                      = data.aws_subnet_ids.this.ids # module.vpc1.private_subnets
      dns_support                                     = true
      ipv6_support                                    = true
      transit_gateway_default_route_table_association = false
      transit_gateway_default_route_table_propagation = false
      //      transit_gateway_route_table_id = "tgw-rtb-073a181ee589b360f"

      tgw_routes = [
        {
          destination_cidr_block = "30.0.0.0/16"
        },
        {
          blackhole              = true
          destination_cidr_block = "0.0.0.0/0"
        }
      ]
    },
  }

  ram_allow_external_principals = true
  ram_principals                = [307990089504]

  tags = {
    Purpose = "tgw-complete-example"
  }
}

module "vpc1" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.0"

  name = "vpc1"

  cidr = "10.10.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]

  enable_ipv6                                    = true
  private_subnet_assign_ipv6_address_on_creation = true
  private_subnet_ipv6_prefixes                   = [0, 1, 2]
}
