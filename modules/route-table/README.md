# AWS Transit Gateway Route Table Terraform module

Terraform module which creates AWS Transit Gateway route table and route resources.

## Usage

```hcl
module "transit_gateway" {
  source  = "terraform-aws-modules/transit-gateway/aws"

  name        = "example"
  description = "Example TGW connecting multiple VPCs"

  # Truncated for brevity ...
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
    vpc2 = {
      transit_gateway_attachment_id = module.transit_gateway.vpc_attachments["vpc2"].id
      propagate_route_table         = true
    }
  }

  routes = {
    blackhole = {
      blackhole              = true
      destination_cidr_block = "0.0.0.0/0"
    }
  }

  vpc_routes = {
    vpc1 = {
      destination_cidr_block = "10.0.0.0/16"
      route_table_id         = "rtb-a73c2ede"
    }
    vpc2 = {
      destination_cidr_block = 10.1.0.0/16"
      route_table_id         = "rtb-852956e2",
    }
  }

  tags = {
    Environment = "Development"
    Project     = "Example"
  }
}
```

## Examples

- [Complete example](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/tree/master/examples/complete) shows TGW in combination with the [VPC module](https://github.com/terraform-aws-modules/terraform-aws-vpc).
- [Multi-account example](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/tree/master/examples/multi-account) shows TGW resources shared with different AWS accounts (via [Resource Access Manager (RAM)](https://aws.amazon.com/ram/)).

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.4 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ec2_transit_gateway_route.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route) | resource |
| [aws_ec2_transit_gateway_route_table.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table) | resource |
| [aws_ec2_transit_gateway_route_table_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_association) | resource |
| [aws_ec2_transit_gateway_route_table_propagation.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_propagation) | resource |
| [aws_route.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_associations"></a> [associations](#input\_associations) | A map of transit gateway attachment IDs to associate with the Transit Gateway route table | <pre>map(object({<br/>    transit_gateway_attachment_id = optional(string)<br/>    replace_existing_association  = optional(bool)<br/>    propagate_route_table         = optional(bool, false)<br/>  }))</pre> | `{}` | no |
| <a name="input_create"></a> [create](#input\_create) | Controls if resources should be created (it affects almost all resources) | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | Name to be used on all the resources as identifier | `string` | `""` | no |
| <a name="input_routes"></a> [routes](#input\_routes) | A map of Transit Gateway routes to create in the route table | <pre>map(object({<br/>    destination_cidr_block        = string<br/>    blackhole                     = optional(bool, false)<br/>    transit_gateway_attachment_id = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_transit_gateway_id"></a> [transit\_gateway\_id](#input\_transit\_gateway\_id) | The ID of the EC2 Transit Gateway | `string` | `""` | no |
| <a name="input_vpc_routes"></a> [vpc\_routes](#input\_vpc\_routes) | A map of VPC routes to create in the route table provided | <pre>map(object({<br/>    route_table_id              = string<br/>    destination_cidr_block      = optional(string)<br/>    destination_ipv6_cidr_block = optional(string)<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | EC2 Transit Gateway Route Table Amazon Resource Name (ARN) |
| <a name="output_id"></a> [id](#output\_id) | EC2 Transit Gateway Route Table identifier |
<!-- END_TF_DOCS -->

## License

Apache 2 Licensed. See [LICENSE](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/tree/master/LICENSE) for full details.
