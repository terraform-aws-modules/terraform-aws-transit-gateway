provider "aws" {
  region = local.region1
}

locals {
  name    = "ex-tgw-${replace(basename(path.cwd), "_", "-")}"
  region1 = "eu-west-1"
  region2 = "eu-north-1"

  tags = {
    Example    = local.name
    GithubRepo = "terraform-aws-eks"
    GithubOrg  = "terraform-aws-transit-gateway"
  }
}

################################################################################
# Transit Gateway Module
################################################################################

module "tgw_region1" {
  source = "../../"

  region = local.region1

  name            = local.name
  description     = "My TGW in ${local.region1}"
  amazon_side_asn = 64532

  share_tgw = false

  tags = local.tags
}

module "tgw_region2" {
  source = "../../"

  region = local.region2

  name            = "${local.name}-peer"
  description     = "My TGW in ${local.region2}"
  amazon_side_asn = 64532

  share_tgw = false

  tags = local.tags
}
