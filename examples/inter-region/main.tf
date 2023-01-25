provider "aws" {
  region = local.region
}

# This provider is required for attachment only installation in another AWS Account
provider "aws" {
  region = local.region_peer
  alias  = "peer"
}

locals {
  name        = "ex-tgw-${replace(basename(path.cwd), "_", "-")}"
  region      = "eu-west-1"
  region_peer = "eu-central-1"

  tags = {
    Example    = local.name
    GithubRepo = "terraform-aws-eks"
    GithubOrg  = "terraform-aws-transit-gateway"
  }
}

################################################################################
# Transit Gateway Module
################################################################################

module "tgw" {
  source = "../../"

  name            = local.name
  description     = "My TGW in ${local.region} region"
  amazon_side_asn = 64532

  create_tgw = true
  share_tgw  = false

  vpc_attachments = {
    vpc1 = {
      vpc_id       = module.vpc1.vpc_id
      subnet_ids   = module.vpc1.private_subnets
      dns_support  = true
      ipv6_support = true

      transit_gateway_default_route_table_association = false
      transit_gateway_default_route_table_propagation = false

      tgw_routes = [
        {
          destination_cidr_block = "10.10.0.0/16"
        },
        {
          blackhole              = true
          destination_cidr_block = "0.0.0.0/0"
        }
      ]
    }
  }

  peering_attachments = {
    peer_frankfurt = {
      peer_account_id         = "307990089504"
      peer_region             = local.region_peer
      peer_transit_gateway_id = module.tgw_peer.ec2_transit_gateway_id
    }
  }

  tags = local.tags
}

module "tgw_peer" {
  source = "../../"

  providers = {
    aws = aws.peer
  }

  name            = "${local.name}-peer"
  description     = "My TGW in ${local.region_peer} region"
  amazon_side_asn = 64533

  create_tgw = true
  share_tgw  = false

  vpc_attachments = {
    vpc2 = {
      tgw_id       = module.tgw.ec2_transit_gateway_id
      vpc_id       = module.vpc2.vpc_id
      subnet_ids   = module.vpc2.private_subnets
      dns_support  = true
      ipv6_support = false

      transit_gateway_default_route_table_association = false
      transit_gateway_default_route_table_propagation = false

      tgw_routes = [
        {
          destination_cidr_block = "10.20.0.0/16"
        },
        {
          blackhole              = true
          destination_cidr_block = "0.0.0.0/0"
        }
      ]
    },
  }

  peering_attachment_accepters = {
    peer_ireland = {
      transit_gateway_peering_attachment_id = module.tgw.ec2_transit_gateway_peering_attachment_ids[0]
    }
  }

  tags = local.tags
}

################################################################################
# Supporting resources
################################################################################

module "vpc1" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

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
  version = "~> 3.0"

  providers = {
    aws = aws.peer
  }

  name = "${local.name}-vpc2"
  cidr = "10.20.0.0/16"

  azs             = ["${local.region_peer}a", "${local.region_peer}b", "${local.region_peer}c"]
  private_subnets = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24"]

  enable_ipv6 = false

  tags = local.tags
}
