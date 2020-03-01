provider "aws" {
  region  = "eu-west-1"
  version = "~> 2.50.0"
}

provider null {
  version = "~> 2.1.2"
}

locals {
  static_routes = [
    "192.168.1.0/24",
    "192.168.3.0/24",
    "192.168.9.0/24"
  ]
  tgw_enabled_on_route_tables_by_tag = {
    tgw_enabled = "true"
  }

}

module "tgw" {
  source = "../../"

  name            = "my-tgw"
  description     = "My TGW shared with several other AWS accounts"
  amazon_side_asn = 64532

  enable_auto_accept_shared_attachments = true // When "true" there is no need for RAM resources if using multiple AWS accounts

  enable_tgw_connectivity_in_vpc_route_tables_by_tags = local.tgw_enabled_on_route_tables_by_tag

  vpn_attachments = {
    vpn-non-prod = {
      vpn_id = "vpn-123456789abcdf"
    }
    vpn-prod = {
      vpn_id = "vpn-abcdf123456789"
    }
  }

  vpc_attachments = {
    vpc-staging = {
      vpc_id     = module.vpc-staging.vpc_id
      subnet_ids = module.vpc-staging.private_subnets
    }
    vpc-integration = {
      vpc_id     = module.vpc-integration.vpc_id
      subnet_ids = module.vpc-integration.private_subnets
    }
    vpc-shared = {
      vpc_id     = module.vpc-shared.vpc_id
      subnet_ids = module.vpc-shared.private_subnets
    }
  }

  transit_route_tables_map = {
    vpn-to-non-prod = {
      associations = ["vpn-non-prod"]
      propagations = [
        "vpc-staging",
        "vpc-integration"
      ]
      static_routes = {
        "blackhole" = [module.vpc-shared.vpc_cidr_block]
      }
    }

    vpc-staging-to-vpn-non-prod = {
      associations = ["vpc-staging"]
      propagations = [
        "vpn-non-prod",
        "vpc-shared"
      ]
      static_routes = {
        "vpn-non-prod" = local.static_routes
        "blackhole"    = [module.vpc-integration.vpc_cidr_block]
      }
    }

    vpc-integration-to-vpn-non-prod = {
      associations = ["vpc-integration"]
      propagations = [
        "vpn-non-prod",
        "vpc-shared"
      ]
      static_routes = {
        "vpn-non-prod" = local.static_routes
        "blackhole"    = [module.vpc-staging.vpc_cidr_block]
      }
    }

    shared = {
      associations = [
        "vpn-prod",
        "vpc-shared"
      ]
      propagations = [
        "vpc-staging",
        "vpc-integration",
        "vpc-shared"
      ]
      static_routes = {
        "vpn-prod" = flatten([local.static_routes, "172.16.1.0/24"])
      }
    }
  }

  ## for different from default configuration, you can put in vpc_attachments additional parameters
  # vpc_attachments = { for vpc_name, vpc_spec in var.vpc_attachments :
  #   vpc_name => {
  #     vpc_id                                          = vpc_spec.vpc_id
  #     subnet_ids                                      = vpc_spec.subnet_ids
  #     dns_support                                     = true
  #     ipv6_support                                    = false
  #     transit_gateway_default_route_table_association = false
  #     transit_gateway_default_route_table_propagation = false
  #   }
  # }

  ram_allow_external_principals = true
  ram_principals                = [307990089504]

  tags = {
    Purpose = "tgw-route-tables-map-example"
  }
}

module "vpc-staging" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.0"

  name = "vpc-staging"

  cidr = "10.10.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]

  enable_ipv6                                    = true
  private_subnet_assign_ipv6_address_on_creation = true
  private_subnet_ipv6_prefixes                   = [0, 1, 2]

  private_subnet_tags = local.tgw_enabled_on_route_tables_by_tag
}

module "vpc-integration" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.0"

  name = "vpc-integration"

  cidr = "10.20.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24"]

  enable_ipv6 = false

  private_subnet_tags = local.tgw_enabled_on_route_tables_by_tag
}

module "vpc-shared" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.0"

  name = "vpc-shared"

  cidr = "10.30.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.30.1.0/24", "10.30.2.0/24", "10.30.3.0/24"]

  enable_ipv6 = false

  private_subnet_tags = local.tgw_enabled_on_route_tables_by_tag
}

