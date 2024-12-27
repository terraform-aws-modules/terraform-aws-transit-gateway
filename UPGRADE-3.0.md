# Upgrade from v2.x to v3.x

Please consult the `examples` directory for reference example configurations. If you find a bug, please open an issue with supporting configuration to reproduce.

## List of backwards incompatible changes

- Minimum supported version of Terraform AWS provider updated to v5.78 to support the latest resources utilized
- Minimum supported version of Terraform updated to v1.3
- Route table and routes have been removed from the root module and into a sub-module. This allows for more flexibility in managing routes and route tables (prior implementation was limited to a single route table and routes). Routes are defined via `maps` instead of `lists`, allowing for individual routes to be added/removed anywhere within the configuration without affecting other routes.
- `aws_ram_resource_share_accepter` resource has been removed and should be managed outside of the module as needed.

## Additional changes

### Added

- Added support for security group referencing
- Added support for flow logs on the Transit Gateway itself, as well as any attachments (as specified)
- Added support for Transit Gateway peering attachments

### Modified

- `vpc_attachments` type definition changed from `any` to full object definition
- RAM sharing of gateway is now set to `false` by default; users must opt into sharing by setting `enable_ram_share = true`
- `transit_gateway_default_route_table_association` is now set to `false` by default
- `transit_gateway_default_route_table_propagation` is now set to `false` by default

### Removed

- `aws_ram_resource_share_accepter` resource has been removed and should be managed outside of the module as needed.

### Variable and output changes

1. Removed variables:

    - `tgw_vpc_attachment_tags`
    - `create_tgw_routes`
    - `transit_gateway_route_table_id`
    - `tgw_route_table_tags`
    - `ram_resource_share_arn`

2. Renamed variables:

    - `create_tgw` -> `create`
    - `enable_default_route_table_association` -> `default_route_table_association`
    - `enable_default_route_table_propagation` -> `default_route_table_propagation`
    - `enable_auto_accept_shared_attachments` -> `auto_accept_shared_attachments`
    - `enable_vpn_ecmp_support` -> `vpn_ecmp_support`
    - `enable_multicast_support` -> `multicast_support`
    - `enable_dns_support` -> `dns_support`
    - `share_tgw` -> `enable_ram_share`

3. Added variables:

    - `security_group_referencing_support`
    - `peering_attachments`
    - `create_flow_log`
    - `flow_logs`

4. Removed outputs:

    - `ec2_transit_gateway_vpc_attachment_ids`
    - `ec2_transit_gateway_vpc_attachment`
    - `ec2_transit_gateway_route_table_id`
    - `ec2_transit_gateway_route_table_default_association_route_table`
    - `ec2_transit_gateway_route_table_default_propagation_route_table`
    - `ec2_transit_gateway_route_ids`
    - `ec2_transit_gateway_route_table_association_ids`
    - `ec2_transit_gateway_route_table_association`
    - `ec2_transit_gateway_route_table_propagation_ids`
    - `ec2_transit_gateway_route_table_propagation`
    - `ram_principal_association_id`

5. Renamed outputs:

    - `ec2_transit_gateway_arn` -> `arn`
    - `ec2_transit_gateway_id` -> `id`
    - `ec2_transit_gateway_owner_id` -> `owner_id`
    - `ec2_transit_gateway_association_default_route_table_id` -> `association_default_route_table`
    - `ec2_transit_gateway_propagation_default_route_table_id` -> `propagation_default_route_table`

6. Added outputs:

    - `vpc_attachments`
    - `peering_attachments`

## Upgrade Migrations

### Before v2.x Example

```hcl
module "transit_gateway" {
  source  = "terraform-aws-modules/transit-gateway/aws"
  version = "~> 2.12"

  name                        = "example"
  description                 = "Example Transit Gateway connecting multiple VPCs"
  amazon_side_asn             = 64532
  transit_gateway_cidr_blocks = ["10.99.0.0/24"]

  enable_auto_accept_shared_attachments = true
  enable_multicast_support              = true

  vpc_attachments = {
    vpc1 = {
      vpc_id       = "vpc-1234556abcdef"
      subnet_ids   = ["subnet-abcde012", "subnet-bcde012a", "subnet-fghi345a"]
      ipv6_support = true

      transit_gateway_default_route_table_association = false
      transit_gateway_default_route_table_propagation = false

      tgw_routes = [
        {
          destination_cidr_block = "30.0.0.0/16"
        },
        {
          blackhole              = true
          destination_cidr_block = "0.0.0.0/0"
        }
      ]
    }

    vpc2 = {
      vpc_id     = module.vpc2.vpc_id
      subnet_ids = module.vpc2.private_subnets

      tgw_routes = [
        {
          destination_cidr_block = "50.0.0.0/16"
        },
        {
          blackhole              = true
          destination_cidr_block = "10.10.10.10/32"
        }
      ]
    }
  }

  tags = {
    Environment = "Development"
    Project     = "Example"
  }
}
```

### After v3.x Example

```hcl
module "transit_gateway" {
  source  = "terraform-aws-modules/transit-gateway/aws"
  version = "3.0.0"

  name                        = "example"
  description                 = "Example Transit Gateway connecting multiple VPCs"
  amazon_side_asn             = 64532
  transit_gateway_cidr_blocks = ["10.99.0.0/24"]

  auto_accept_shared_attachments = true
  multicast_support              = true

  # Maintain backwards compatibility
  security_group_referencing_support = false
  default_route_table_association    = true
  default_route_table_propagation    = true

  vpc_attachments = {
    vpc1 = {
      vpc_id       = "vpc-1234556abcdef"
      subnet_ids   = ["subnet-abcde012", "subnet-bcde012a", "subnet-fghi345a"]
      ipv6_support = true

      # Maintain backwards compatibility
      security_group_referencing_support = true
    }

    vpc2 = {
      vpc_id     = "vpc-98765432d1aad"
      subnet_ids = ["subnet-334de012", "subnet-6vfe012a", "subnet-agfi435a"]

      # Maintain backwards compatibility
      security_group_referencing_support              = true
      transit_gateway_default_route_table_association = true
      transit_gateway_default_route_table_propagation = true
    }
  }

  tags = {
    Environment = "Development"
    Project     = "Example"
  }
}

module "transit_gateway_route_table" {
  source  = "terraform-aws-modules/transit-gateway/aws//modules/route-table"

  name               = "example"
  transit_gateway_id = module.transit_gateway.id

  associations = {
    vpc1 = {
      transit_gateway_attachment_id = module.transit_gateway.vpc_attachments["vpc1"].id
      propagate_route_table         = true
    }
  }

  routes = {
    blackhole = {
      blackhole              = true
      destination_cidr_block = "0.0.0.0/0"
    }
    blackhole2 = {
      blackhole              = true
      destination_cidr_block = "10.10.10.10/32"
    }
    vpc1-thing = {
      destination_cidr_block        = "30.0.0.0/16"
      transit_gateway_attachment_id = module.transit_gateway.vpc_attachments["vpc1"].id
    }
    vpc2-thing = {
      destination_cidr_block        = "50.0.0.0/16"
      transit_gateway_attachment_id = module.transit_gateway.vpc_attachments["vpc2"].id
    }
  }

  tags = {
    Environment = "Development"
    Project     = "Example"
  }
}
```

### State Move Commands

In conjunction with the changes above, users can elect to move their external capacity provider(s) under this module using the following move command. Command is shown using the values from the example shown above, please update to suit your configuration names:

```sh
terraform state mv 'module.transit_gateway.aws_ec2_transit_gateway_route_table.this[0]' 'module.transit_gateway_route_table.aws_ec2_transit_gateway_route_table.this[0]'

terraform state mv 'module.transit_gateway.aws_ec2_transit_gateway_route_table_association.this["vpc1"]' 'module.transit_gateway_route_table.aws_ec2_transit_gateway_route_table_association.this["vpc1"]'
terraform state mv 'module.transit_gateway.aws_ec2_transit_gateway_route_table_propagation.this["vpc1"]' 'module.transit_gateway_route_table.aws_ec2_transit_gateway_route_table_propagation.this["vpc1"]'

terraform state mv 'module.transit_gateway.aws_ec2_transit_gateway_route.this[0]' 'module.transit_gateway_route_table.aws_ec2_transit_gateway_route.this["vpc1-thing"]'
terraform state mv 'module.transit_gateway.aws_ec2_transit_gateway_route.this[1]' 'module.transit_gateway_route_table.aws_ec2_transit_gateway_route.this["blackhole"]'
terraform state mv 'module.transit_gateway.aws_ec2_transit_gateway_route.this[2]' 'module.transit_gateway_route_table.aws_ec2_transit_gateway_route.this["vpc2-thing"]'
terraform state mv 'module.transit_gateway.aws_ec2_transit_gateway_route.this[3]' 'module.transit_gateway_route_table.aws_ec2_transit_gateway_route.this["blackhole2"]'
```
