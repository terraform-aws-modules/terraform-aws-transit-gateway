provider "aws" {
  region = local.region_a
}

provider "aws" {
  alias  = "region_b"
  region = local.region_b
}

data "aws_availability_zones" "available" {}

locals {
  name     = "ex-${basename(path.cwd)}"
  region_a = "eu-west-1"
  region_b = "eu-central-1"

  vpc_a_cidr = "10.10.0.0/16"
  vpc_b_cidr = "10.20.0.0/16"

  tags = {
    Example    = local.name
    Repository = "https://github.com/terraform-aws-modules/terraform-aws-transit-gateway"
  }
}

################################################################################
# Region A: the hub, and the side that requests the peering
################################################################################

module "tgw_a" {
  source = "../.."

  name        = "${local.name}-a"
  description = "Hub in ${local.region_a}"

  # A peering attachment carries static routes only, so the default route table
  # associations are left on and routes are added explicitly below
  enable_auto_accept_shared_attachments = true

  vpc_attachments = {
    vpc = {
      vpc_id     = module.vpc_a.vpc_id
      subnet_ids = module.vpc_a.private_subnets
    }
  }

  # Peer to the other Region. The far side has to accept it
  peering_attachments = {
    to_region_b = {
      peer_transit_gateway_id = module.tgw_b.ec2_transit_gateway_id
      peer_region             = local.region_b
    }
  }

  tags = local.tags
}

################################################################################
# Region B: the side that accepts the peering
################################################################################

module "tgw_b" {
  source = "../.."

  providers = { aws = aws.region_b }

  name        = "${local.name}-b"
  description = "Hub in ${local.region_b}"

  enable_auto_accept_shared_attachments = true

  vpc_attachments = {
    vpc = {
      vpc_id     = module.vpc_b.vpc_id
      subnet_ids = module.vpc_b.private_subnets
    }
  }

  tags = local.tags
}

# Accepted separately, because the attachment must exist before it can be accepted and
# the accepter runs with the far Region's credentials
module "tgw_b_peering_accepter" {
  source = "../.."

  providers = { aws = aws.region_b }

  create_tgw = false
  # this instance exists only to accept the peering attachment, it consumes no RAM share
  share_tgw = false
  name      = "${local.name}-b-accepter"

  peering_attachment_accepters = {
    from_region_a = {
      transit_gateway_attachment_id = module.tgw_a.ec2_transit_gateway_peering_attachment["to_region_b"].id
    }
  }

  tags = local.tags
}

################################################################################
# Supporting Resources
################################################################################

module "vpc_a" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name            = "${local.name}-a"
  cidr            = local.vpc_a_cidr
  azs             = slice(data.aws_availability_zones.available.names, 0, 2)
  private_subnets = [for i in range(2) : cidrsubnet(local.vpc_a_cidr, 8, i)]

  tags = local.tags
}

module "vpc_b" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  providers = { aws = aws.region_b }

  name            = "${local.name}-b"
  cidr            = local.vpc_b_cidr
  azs             = ["${local.region_b}a", "${local.region_b}b"]
  private_subnets = [for i in range(2) : cidrsubnet(local.vpc_b_cidr, 8, i)]

  tags = local.tags
}
