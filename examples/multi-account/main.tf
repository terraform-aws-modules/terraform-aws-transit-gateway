provider "aws" {
  region = local.primary_region
}

# This provider is required for TGW and peering attachment installation in another AWS Account
provider "aws" {
  region = local.secondary_region
  alias  = "peer_hub"
}

# This provider is required for attachment only installation in another AWS Account
provider "aws" {
  region = local.primary_region
  alias  = "primary_spoke"
}

# This provider is required for attachment only installation in another AWS Account
provider "aws" {
  region = local.secondary_region
  alias  = "peer_spoke"
}

locals {
  name = "ex-tgw-${replace(basename(path.cwd), "_", "-")}"

  primary_region   = "eu-west-1"
  secondary_region = "eu-west-2"

  primary_hub_account_id   = "012345678901"
  peer_hub_account_id      = "123456789012"
  primary_spoke_account_id = "234567890123"
  peer_spoke_account_id    = "345678901234"

  primary_hub_flow_logs_cloudwatch_dest_arn     = "arn:aws:logs:${local.primary_region}:${local.primary_hub_account_id}:log-group:/aws/tgw/"
  primary_hub_flow_logs_cloudwatch_iam_role_arn = "arn:aws:iam::${local.primary_hub_account_id}:role/tgw-flow-logs-to-cloudwatch"
  primary_hub_flow_logs_s3_dest_arn             = "arn:aws:s3:::tgw-flow-logs-${local.primary_hub_account_id}-${local.primary_region}"

  primary_spoke_flow_logs_cloudwatch_dest_arn     = "arn:aws:logs:${local.primary_region}:${local.primary_spoke_account_id}:log-group:/aws/tgw/"
  primary_spoke_flow_logs_cloudwatch_iam_role_arn = "arn:aws:iam::${local.primary_spoke_account_id}:role/tgw-flow-logs-to-cloudwatch"
  primary_spoke_flow_logs_s3_dest_arn             = "arn:aws:s3:::tgw-flow-logs-${local.primary_spoke_account_id}-${local.primary_region}"

  peer_hub_flow_logs_cloudwatch_dest_arn     = "arn:aws:logs:${local.secondary_region}:${local.peer_hub_account_id}:log-group:/aws/tgw/"
  peer_hub_flow_logs_cloudwatch_iam_role_arn = "arn:aws:iam::${local.peer_hub_account_id}:role/tgw-flow-logs-to-cloudwatch"
  peer_hub_flow_logs_s3_dest_arn             = "arn:aws:s3:::tgw-flow-logs-${local.peer_hub_account_id}-${local.secondary_region}"

  peer_spoke_flow_logs_cloudwatch_dest_arn     = "arn:aws:logs:${local.secondary_region}:${local.peer_spoke_account_id}:log-group:/aws/tgw/"
  peer_spoke_flow_logs_cloudwatch_iam_role_arn = "arn:aws:iam::${local.peer_spoke_account_id}:role/tgw-flow-logs-to-cloudwatch"
  peer_spoke_flow_logs_s3_dest_arn             = "arn:aws:s3:::tgw-flow-logs-${local.peer_spoke_account_id}-${local.secondary_region}"

  tags = {
    Example    = local.name
    GithubRepo = "terraform-aws-transit-gateway"
  }
}

################################################################################
# Transit Gateway Module
################################################################################

module "primary_hub" {
  source = "../../"

  name            = local.name
  description     = "Primary Hub TGW shared with several other AWS accounts in ${local.primary_region}"
  amazon_side_asn = 64532

  # Creates RAM resources for hub (create_tgw = true) accounts
  share_tgw = true

  # When "true" there is no need for RAM resources if using multiple AWS accounts
  enable_auto_accept_shared_attachments = false

  enable_default_route_table_association = false
  enable_default_route_table_propagation = false

  flow_logs = [
    {
      cloudwatch_dest_arn     = local.primary_hub_flow_logs_cloudwatch_dest_arn
      cloudwatch_iam_role_arn = local.primary_hub_flow_logs_cloudwatch_iam_role_arn
      # Enable destinations after all TGWs/attachments are created/accepted
      dest_enabled = true
      dest_type    = "cloud-watch-logs"
      key          = "tgw"
      s3_dest_arn  = null
    },
    {
      cloudwatch_dest_arn     = null
      cloudwatch_iam_role_arn = null
      # Enable destinations after all TGWs/attachments are created/accepted
      dest_enabled = true
      dest_type    = "s3"
      key          = "tgw"
      s3_dest_arn  = local.primary_hub_flow_logs_s3_dest_arn
    },
    {
      attachment_type         = "vpc"
      cloudwatch_dest_arn     = local.primary_hub_flow_logs_cloudwatch_dest_arn
      cloudwatch_iam_role_arn = local.primary_hub_flow_logs_cloudwatch_iam_role_arn
      create_tgw_peering      = false
      create_vpc_attachment   = true
      # Enable destinations after all TGWs/attachments are created/accepted
      dest_enabled = true
      dest_type    = "cloud-watch-logs"
      key          = "primary_hub_local"
      s3_dest_arn  = null
    },
    {
      attachment_type         = "vpc"
      cloudwatch_dest_arn     = null
      cloudwatch_iam_role_arn = null
      create_tgw_peering      = false
      create_vpc_attachment   = true
      # Enable destinations after all TGWs/attachments are created/accepted
      dest_enabled = true
      dest_type    = "s3"
      key          = "primary_hub_local"
      s3_dest_arn  = local.primary_hub_flow_logs_s3_dest_arn
    },
    {
      attachment_type         = "peering"
      cloudwatch_dest_arn     = local.primary_hub_flow_logs_cloudwatch_dest_arn
      cloudwatch_iam_role_arn = local.primary_hub_flow_logs_cloudwatch_iam_role_arn
      create_tgw_peering      = true
      create_vpc_attachment   = false
      # Enable destinations after all TGWs/attachments are created/accepted
      dest_enabled = true
      dest_type    = "cloud-watch-logs"
      key          = "peer_hub"
      s3_dest_arn  = null
    },
    {
      attachment_type         = "peering"
      cloudwatch_dest_arn     = null
      cloudwatch_iam_role_arn = null
      create_tgw_peering      = true
      create_vpc_attachment   = false
      # Enable destinations after all TGWs/attachments are created/accepted
      dest_enabled = true
      dest_type    = "s3"
      key          = "peer_hub"
      s3_dest_arn  = local.primary_hub_flow_logs_s3_dest_arn
    },
  ]

  attachments = {
    peer_hub = {
      attachment_type     = "peering"
      create_tgw_peering  = true
      peer_account_id     = local.peer_hub_account_id
      peer_region         = local.secondary_region
      peer_tgw_id         = module.peer_hub.ec2_transit_gateway_id
      vpc_route_table_ids = module.primary_hub_vpc.private_route_table_ids
      # Keep create_vpc_routes = false until the TGW is created and all attachments are created/accepted
      create_vpc_routes = false
      vpc_route_table_destination_cidrs = [
        module.peer_hub_vpc.vpc_cidr_block,
      ]
      transit_gateway_default_route_table_association = false
      transit_gateway_default_route_table_propagation = false
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
        peer_hub = {
          destination_cidr_blocks = module.peer_hub_vpc.vpc_cidr_block
          route_table             = "prod"
        }
        blackhole = {
          blackhole               = true
          destination_cidr_blocks = "0.0.0.0/0"
          route_table             = "prod"
        }
      }
    }
    primary_hub_local = {
      attachment_type       = "vpc"
      create_vpc_attachment = true
      # Keep enable_vpc_attachment = false until the corresponding VPC attachment is created/accepted
      enable_vpc_attachment                           = false
      vpc_id                                          = module.primary_hub_vpc.vpc_id
      subnet_ids                                      = module.primary_hub_vpc.private_subnets
      transit_gateway_default_route_table_association = false
      transit_gateway_default_route_table_propagation = false
      ipv6_support                                    = true
      # Keep create_tgw_routes = false until the VPC/peering attachments exist/are accepted
      create_tgw_routes = true
      tgw_route_table_propagations = {
        prod = {
          enable = true
        }
      }
      tgw_routes = {
        primary_hub_local = {
          destination_cidr_blocks = module.primary_hub_vpc.vpc_cidr_block
          route_table             = "prod"
        }
        blackhole = {
          blackhole               = true
          destination_cidr_blocks = "0.0.0.0/0"
          route_table             = "prod"
        }
      }
    }
    primary_spoke = {
      attachment_type = "vpc"
      # Keep accept_vpc_attachment = false until the corresponding VPC attachment is created
      accept_vpc_attachment = false
      # Keep enable_vpc_attachment = false until the corresponding VPC attachment is created
      # Set to true when accepting the attachment
      enable_vpc_attachment = false
      vpc_id                = module.primary_spoke_vpc.vpc_id
      vpc_route_table_ids   = module.primary_hub_vpc.private_route_table_ids
      # Keep create_vpc_routes = false until the TGW is created and all attachments are created/accepted
      create_vpc_routes = false
      vpc_route_table_destination_cidrs = [
        module.primary_spoke_vpc.vpc_cidr_block,
      ]
      transit_gateway_default_route_table_association = false
      transit_gateway_default_route_table_propagation = false
      # Keep create_tgw_routes = false until the VPC/peering attachments exist/are accepted
      create_tgw_routes = true
      tgw_route_table_propagations = {
        staging = {
          enable = true
        }
      }
      tgw_routes = {
        primary_spoke = {
          destination_cidr_blocks = module.primary_spoke_vpc.private_subnets_cidr_blocks
          route_table             = "staging"
        }
        blackhole = {
          blackhole               = true
          destination_cidr_blocks = ["0.0.0.0/0"]
          route_table             = "staging"
        }
      }
    }
    peer_spoke = {
      attachment_type = "peering"
      # For peering attachments that aren't accepted by this module, keep enable_peering_attachment = false until the peering attachment is accepted
      enable_peering_attachment = true
      peer_account_id           = local.peer_hub_account_id
      vpc_route_table_ids       = module.primary_hub_vpc.private_route_table_ids
      # Keep create_vpc_routes = false until the TGW is created and all attachments are created/accepted
      create_vpc_routes = false
      vpc_route_table_destination_cidrs = [
        module.peer_spoke_vpc.vpc_cidr_block,
      ]
      transit_gateway_default_route_table_association = false
      transit_gateway_default_route_table_propagation = false
      # Keep create_tgw_routes = false until the VPC/peering attachments exist/are accepted
      create_tgw_routes = true
      tgw_routes = {
        peer_spoke = {
          destination_cidr_blocks = module.peer_spoke_vpc.private_subnets_cidr_blocks
          route_table             = "staging"
        }
        blackhole = {
          blackhole               = true
          destination_cidr_blocks = ["0.0.0.0/0"]
          route_table             = "staging"
        }
      }
    }
  }

  ram_allow_external_principals = false
  ram_principals = [
    local.peer_hub_account_id,
    local.primary_spoke_account_id,
  ]

  tags = local.tags
}

module "peer_hub" {
  # This is optional and connects to another account. Meaning you need to be authenticated with multiple separate AWS Accounts
  source = "../../"

  providers = {
    aws = aws.peer_hub
  }

  name            = "${local.name}-peer-hub"
  description     = "Peer Hub TGW shared with several other AWS accounts in ${local.secondary_region}"
  amazon_side_asn = 64532

  # Creates RAM resources for hub (create_tgw = true) accounts
  share_tgw = true

  # When "true" there is no need for RAM resources if using multiple AWS accounts
  enable_auto_accept_shared_attachments = false

  enable_default_route_table_association = false
  enable_default_route_table_propagation = false

  flow_logs = [
    {
      cloudwatch_dest_arn     = local.peer_hub_flow_logs_cloudwatch_dest_arn
      cloudwatch_iam_role_arn = local.peer_hub_flow_logs_cloudwatch_iam_role_arn
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
      s3_dest_arn             = local.peer_hub_flow_logs_s3_dest_arn
    },
    {
      attachment_type         = "vpc"
      cloudwatch_dest_arn     = local.peer_hub_flow_logs_cloudwatch_dest_arn
      cloudwatch_iam_role_arn = local.peer_hub_flow_logs_cloudwatch_iam_role_arn
      create_tgw_peering      = false
      create_vpc_attachment   = true
      dest_enabled            = true
      dest_type               = "cloud-watch-logs"
      key                     = "peer_hub_local"
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
      key                     = "peer_hub_local"
      s3_dest_arn             = local.peer_hub_flow_logs_s3_dest_arn
    },
  ]

  attachments = {
    primary_hub = {
      attachment_type = "peering"
      # Keep accept_tgw_peering = false until the peering attachment is created in the hub account
      accept_tgw_peering = true
      # For peering attachments to be accepted, keep enable_peering_attachment = false until the peering attachment is created in the hub account
      # Set to true when accepting the attachment
      enable_peering_attachment = true
      peer_account_id           = local.primary_hub_account_id
      vpc_route_table_ids       = module.peer_hub_vpc.private_route_table_ids
      # Keep create_vpc_routes = false until the TGW is created and all attachments are created/accepted
      create_vpc_routes = false
      vpc_route_table_destination_cidrs = [
        module.primary_hub_vpc.vpc_cidr_block,
      ]
      transit_gateway_default_route_table_association = false
      transit_gateway_default_route_table_propagation = false
      # Keep create_tgw_routes = false until the VPC/peering attachments exist/are accepted
      create_tgw_routes = true
      tgw_routes = {
        primary_hub = {
          destination_cidr_blocks = module.primary_hub_vpc.private_subnets_cidr_blocks
          route_table             = "prod"
        }
        blackhole = {
          blackhole               = true
          destination_cidr_blocks = ["0.0.0.0/0"]
        }
      }
    }
    peer_hub_local = {
      attachment_type       = "vpc"
      create_vpc_attachment = true
      # Keep enable_vpc_attachment = false until the corresponding VPC attachment is created/accepted
      enable_vpc_attachment                           = false
      vpc_id                                          = module.peer_hub_vpc.vpc_id
      subnet_ids                                      = module.peer_hub_vpc.private_subnets
      transit_gateway_default_route_table_association = false
      transit_gateway_default_route_table_propagation = false
      ipv6_support                                    = true
      # Keep create_tgw_routes = false until the VPC/peering attachments exist/are accepted
      create_tgw_routes = true
      tgw_route_table_propagations = {
        prod = {
          enable = true
        }
      }
      tgw_routes = {
        peer_hub_local = {
          destination_cidr_blocks = module.peer_hub_vpc.private_subnets_cidr_blocks
          route_table             = "prod"
        }
        blackhole = {
          blackhole               = true
          destination_cidr_blocks = ["0.0.0.0/0"]
        }
      }
    }
    peer_spoke = {
      attachment_type = "vpc"
      # Keep accept_vpc_attachment = false until the corresponding VPC attachment is created
      accept_vpc_attachment = false
      # Keep enable_vpc_attachment = false until the corresponding VPC attachment is created/accepted
      enable_vpc_attachment = false
      vpc_id                = module.peer_spoke_vpc.vpc_id
      vpc_route_table_ids   = module.peer_hub_vpc.private_route_table_ids
      # Keep create_vpc_routes = false until the TGW is created and all attachments are created/accepted
      create_vpc_routes = false
      vpc_route_table_destination_cidrs = [
        module.peer_spoke_vpc.vpc_cidr_block,
      ]
      transit_gateway_default_route_table_association = false
      transit_gateway_default_route_table_propagation = false
      # Keep create_tgw_routes = false until the VPC/peering attachments exist/are accepted
      create_tgw_routes = true
      tgw_route_table_propagations = {
        staging = {
          enable = true
        }
      }
      tgw_routes = {
        peer_spoke_account = {
          destination_cidr_blocks = module.peer_spoke_vpc.private_subnets_cidr_blocks
          route_table             = "staging"
        }
        blackhole = {
          blackhole               = true
          destination_cidr_blocks = ["0.0.0.0/0"]
        }
      }
    }
    primary_spoke = {
      attachment_type = "peering"
      # For peering attachments that aren't accepted by this module, keep enable_peering_attachment = false until the peering attachment is accepted
      enable_peering_attachment = true
      peer_account_id           = local.primary_hub_account_id
      vpc_route_table_ids       = module.peer_hub_vpc.private_route_table_ids
      # Keep create_vpc_routes = false until the TGW is created and all attachments are created/accepted
      create_vpc_routes = false
      vpc_route_table_destination_cidrs = [
        module.primary_spoke_vpc.vpc_cidr_block,
      ]
      transit_gateway_default_route_table_association = false
      transit_gateway_default_route_table_propagation = false
      # Keep create_tgw_routes = false until the VPC/peering attachments exist/are accepted
      create_tgw_routes = true
      tgw_routes = {
        primary_spoke = {
          destination_cidr_blocks = module.primary_spoke_vpc.private_subnets_cidr_blocks
          route_table             = "staging"
        }
        blackhole = {
          blackhole               = true
          destination_cidr_blocks = ["0.0.0.0/0"]
        }
      }
    }
  }

  ram_allow_external_principals = false
  ram_principals = [
    local.primary_hub_account_id,
    local.peer_spoke_account_id,
  ]

  tags = local.tags
}

module "primary_spoke" {
  # This is optional and connects to another account. Meaning you need to be authenticated with multiple separate AWS Accounts
  source = "../../"

  providers = {
    aws = aws.primary_spoke
  }

  # Creates RAM Resource Share Accepter for spoke (create_tgw = false) accounts
  share_tgw = true

  description = "Primary Spoke sharing the TGW from the Primary Hub in ${local.primary_region}"

  flow_logs = [
    {
      attachment_type         = "vpc"
      cloudwatch_dest_arn     = local.primary_spoke_flow_logs_cloudwatch_dest_arn
      cloudwatch_iam_role_arn = local.primary_spoke_flow_logs_cloudwatch_iam_role_arn
      create_tgw_peering      = false
      create_vpc_attachment   = true
      dest_enabled            = true
      dest_type               = "cloud-watch-logs"
      key                     = "primary_spoke_local"
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
      key                     = "primary_spoke_local"
      s3_dest_arn             = local.primary_spoke_flow_logs_s3_dest_arn
    },
  ]

  attachments = {
    primary_spoke_local = {
      attachment_type       = "vpc"
      create_vpc_attachment = true
      # Keep enable_vpc_attachment = false until the corresponding VPC attachment is created/accepted
      enable_vpc_attachment = false
      tgw_id                = module.primary_hub.ec2_transit_gateway_id
      vpc_id                = module.primary_spoke_vpc.vpc_id
      subnet_ids            = module.primary_spoke_vpc.private_subnets
      ipv6_support          = true
    }
    primary_hub = {
      attachment_type = "vpc"
      # Keep enable_vpc_attachment = false until the corresponding VPC attachment is created/accepted
      enable_vpc_attachment = false
      tgw_id                = module.primary_hub.ec2_transit_gateway_id
      vpc_route_table_ids   = module.primary_spoke_vpc.private_route_table_ids
      vpc_route_table_destination_cidrs = [
        module.primary_hub_vpc.vpc_cidr_block,
      ]
    }
    peer_hub = {
      attachment_type     = "peering"
      tgw_id              = module.primary_hub.ec2_transit_gateway_id
      vpc_route_table_ids = module.primary_spoke_vpc.private_route_table_ids
      vpc_route_table_destination_cidrs = [
        module.peer_hub_vpc.vpc_cidr_block,
      ]
    }
    peer_spoke = {
      attachment_type     = "peering"
      tgw_id              = module.primary_hub.ec2_transit_gateway_id
      vpc_route_table_ids = module.primary_spoke_vpc.private_route_table_ids
      vpc_route_table_destination_cidrs = [
        module.peer_spoke_vpc.vpc_cidr_block,
      ]
    }
  }

  tags = local.tags
}

module "peer_spoke" {
  # This is optional and connects to another account. Meaning you need to be authenticated with multiple separate AWS Accounts
  source = "../../"

  providers = {
    aws = aws.peer_spoke
  }

  # Creates RAM Resource Share Accepter for spoke (create_tgw = false) accounts
  share_tgw = true

  description = "Peer Spoke sharing the TGW from the Peer Hub in ${local.secondary_region}"

  flow_logs = [
    {
      attachment_type         = "vpc"
      cloudwatch_dest_arn     = local.peer_spoke_flow_logs_cloudwatch_dest_arn
      cloudwatch_iam_role_arn = local.peer_spoke_flow_logs_cloudwatch_iam_role_arn
      create_tgw_peering      = false
      create_vpc_attachment   = true
      dest_enabled            = true
      dest_type               = "cloud-watch-logs"
      key                     = "peer_spoke_local"
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
      key                     = "peer_spoke_local"
      s3_dest_arn             = local.peer_spoke_flow_logs_s3_dest_arn
    },
  ]

  attachments = {
    peer_spoke_local = {
      attachment_type       = "vpc"
      create_vpc_attachment = true
      # Keep enable_vpc_attachment = false until the corresponding VPC attachment is created/accepted
      enable_vpc_attachment = false
      tgw_id                = module.peer_hub.ec2_transit_gateway_id
      vpc_id                = module.peer_spoke_vpc.vpc_id
      subnet_ids            = module.peer_spoke_vpc.private_subnets
      ipv6_support          = true
    }
    peer_hub = {
      attachment_type = "vpc"
      # Keep enable_vpc_attachment = false until the corresponding VPC attachment is created/accepted
      enable_vpc_attachment = false
      tgw_id                = module.peer_hub.ec2_transit_gateway_id
      vpc_route_table_ids   = module.peer_spoke_vpc.private_route_table_ids
      # Keep create_vpc_routes = false until the TGW is created and all attachments are created/accepted
      create_vpc_routes = false
      vpc_route_table_destination_cidrs = [
        module.peer_hub_vpc.vpc_cidr_block,
      ]
    }
    primary_hub = {
      attachment_type     = "peering"
      tgw_id              = module.peer_hub.ec2_transit_gateway_id
      vpc_route_table_ids = module.peer_spoke_vpc.private_route_table_ids
      # Keep create_vpc_routes = false until the TGW is created and all attachments are created/accepted
      create_vpc_routes = false
      vpc_route_table_destination_cidrs = [
        module.primary_hub_vpc.vpc_cidr_block,
      ]
    }
    primary_spoke = {
      attachment_type     = "peering"
      tgw_id              = module.peer_hub.ec2_transit_gateway_id
      vpc_route_table_ids = module.peer_spoke_vpc.private_route_table_ids
      # Keep create_vpc_routes = false until the TGW is created and all attachments are created/accepted
      create_vpc_routes = false
      vpc_route_table_destination_cidrs = [
        module.primary_spoke_vpc.vpc_cidr_block,
      ]
    }
  }

  tags = local.tags
}

################################################################################
# Supporting resources
################################################################################

module "primary_hub_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${local.name}-primary-hub-vpc"
  cidr = "10.10.0.0/16"

  azs             = ["${local.primary_region}a", "${local.primary_region}b", "${local.primary_region}c"]
  private_subnets = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]

  enable_ipv6                                    = true
  private_subnet_assign_ipv6_address_on_creation = true
  private_subnet_ipv6_prefixes                   = [0, 1, 2]

  tags = local.tags
}


module "peer_hub_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  providers = {
    aws = aws.peer_hub
  }

  name = "${local.name}-peer-hub-vpc"
  cidr = "10.20.0.0/16"

  azs             = ["${local.secondary_region}a", "${local.secondary_region}b", "${local.secondary_region}c"]
  private_subnets = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24"]

  enable_ipv6                                    = true
  private_subnet_assign_ipv6_address_on_creation = true
  private_subnet_ipv6_prefixes                   = [3, 4, 5]

  tags = local.tags
}

module "primary_spoke_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  providers = {
    aws = aws.primary_spoke
  }

  name = "${local.name}-primary-spoke-vpc"
  cidr = "10.30.0.0/16"

  azs             = ["${local.primary_region}a", "${local.primary_region}b", "${local.primary_region}c"]
  private_subnets = ["10.30.1.0/24", "10.30.2.0/24", "10.30.3.0/24"]

  enable_ipv6                                    = true
  private_subnet_assign_ipv6_address_on_creation = true
  private_subnet_ipv6_prefixes                   = [0, 1, 2]

  tags = local.tags
}

module "peer_spoke_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  providers = {
    aws = aws.peer_spoke
  }

  name = "${local.name}-peer-spoke-vpc"
  cidr = "10.40.0.0/16"

  azs             = ["${local.secondary_region}a", "${local.secondary_region}b", "${local.secondary_region}c"]
  private_subnets = ["10.40.1.0/24", "10.40.2.0/24", "10.40.3.0/24"]

  enable_ipv6                                    = true
  private_subnet_assign_ipv6_address_on_creation = true
  private_subnet_ipv6_prefixes                   = [9, 10, 11]

  tags = local.tags
}
