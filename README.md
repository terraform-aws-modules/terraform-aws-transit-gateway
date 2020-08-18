# AWS Transit Gateway Terraform module

Terraform module which creates Transit Gateway resources on AWS.

This type of resources are supported:

* [Transit Gateway](https://www.terraform.io/docs/providers/aws/r/ec2_transit_gateway.html)
* [Transit Gateway Route](https://www.terraform.io/docs/providers/aws/r/ec2_transit_gateway_route.html)
* [Transit Gateway Route Table](https://www.terraform.io/docs/providers/aws/r/ec2_transit_gateway_route_table.html)
* [Transit Gateway Route Table Association](https://www.terraform.io/docs/providers/aws/r/ec2_transit_gateway_route_table_association.html)
* [Transit Gateway Route Table Propagation](https://www.terraform.io/docs/providers/aws/r/ec2_transit_gateway_route_table_propagation.html)
* [Transit Gateway VPC Attachment](https://www.terraform.io/docs/providers/aws/r/ec2_transit_gateway_vpc_attachment.html)

Not supported yet:

* [Transit Gateway VPC Attachment Accepter](https://www.terraform.io/docs/providers/aws/r/ec2_transit_gateway_vpc_attachment_accepter.html)

## Terraform versions

Only Terraform 0.12 or newer is supported.

## Usage with VPC module

```hcl
module "tgw" {
  source  = "terraform-aws-modules/transit-gateway/aws"
  version = "~> 1.0"
  
  name        = "my-tgw"
  description = "My TGW shared with several other AWS accounts"
  
  enable_auto_accept_shared_attachments = true

  vpc_attachments = {
    vpc = {
      vpc_id       = module.vpc.vpc_id
      subnet_ids   = module.vpc.private_subnets
      dns_support  = true
      ipv6_support = true

      tgw_routes = [
        {
          destination_cidr_block = "30.0.0.0/16"
        },
        {
          blackhole = true
          destination_cidr_block = "40.0.0.0/20"
        }
      ]
    }
  }

  ram_allow_external_principals = true
  ram_principals = [307990089504]

  tags = {
    Purpose = "tgw-complete-example"
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.0"

  name = "my-vpc"

  cidr = "10.10.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]

  enable_ipv6                                    = true
  private_subnet_assign_ipv6_address_on_creation = true
  private_subnet_ipv6_prefixes                   = [0, 1, 2]
}
```

## Examples

* [Complete example](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/tree/master/examples/complete) shows TGW in combination with the [VPC module](https://github.com/terraform-aws-modules/terraform-aws-vpc) and [Resource Access Manager (RAM)](https://aws.amazon.com/ram/).
* [Multi-account example](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/tree/master/examples/multi-account) shows TGW resources shared with different AWS accounts (via [Resource Access Manager (RAM)](https://aws.amazon.com/ram/)).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.7, < 0.14 |
| aws | >= 2.24, < 4.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.24, < 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| amazon\_side\_asn | The Autonomous System Number (ASN) for the Amazon side of the gateway. By default the TGW is created with the current default Amazon ASN. | `string` | `"64512"` | no |
| create\_tgw | Controls if TGW should be created (it affects almost all resources) | `bool` | `true` | no |
| description | Description of the EC2 Transit Gateway | `string` | `null` | no |
| enable\_auto\_accept\_shared\_attachments | Whether resource attachment requests are automatically accepted | `bool` | `false` | no |
| enable\_default\_route\_table\_association | Whether resource attachments are automatically associated with the default association route table | `bool` | `true` | no |
| enable\_default\_route\_table\_propagation | Whether resource attachments automatically propagate routes to the default propagation route table | `bool` | `true` | no |
| enable\_dns\_support | Should be true to enable DNS support in the TGW | `bool` | `true` | no |
| enable\_vpn\_ecmp\_support | Whether VPN Equal Cost Multipath Protocol support is enabled | `bool` | `true` | no |
| name | Name to be used on all the resources as identifier | `string` | `""` | no |
| ram\_allow\_external\_principals | Indicates whether principals outside your organization can be associated with a resource share. | `bool` | `false` | no |
| ram\_name | The name of the resource share of TGW | `string` | `""` | no |
| ram\_principals | A list of principals to share TGW with. Possible values are an AWS account ID, an AWS Organizations Organization ARN, or an AWS Organizations Organization Unit ARN | `list(string)` | `[]` | no |
| ram\_resource\_share\_arn | ARN of RAM resource share | `string` | `""` | no |
| ram\_tags | Additional tags for the RAM | `map(string)` | `{}` | no |
| share\_tgw | Whether to share your transit gateway with other accounts | `bool` | `true` | no |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |
| tgw\_route\_table\_tags | Additional tags for the TGW route table | `map(string)` | `{}` | no |
| tgw\_tags | Additional tags for the TGW | `map(string)` | `{}` | no |
| tgw\_vpc\_attachment\_tags | Additional tags for VPC attachments | `map(string)` | `{}` | no |
| transit\_gateway\_route\_table\_id | Identifier of EC2 Transit Gateway Route Table to use with the Target Gateway when reusing it between multiple TGWs | `string` | `null` | no |
| vpc\_attachments | Maps of maps of VPC details to attach to TGW. Type 'any' to disable type validation by Terraform. | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| this\_ec2\_transit\_gateway\_arn | EC2 Transit Gateway Amazon Resource Name (ARN) |
| this\_ec2\_transit\_gateway\_association\_default\_route\_table\_id | Identifier of the default association route table |
| this\_ec2\_transit\_gateway\_id | EC2 Transit Gateway identifier |
| this\_ec2\_transit\_gateway\_owner\_id | Identifier of the AWS account that owns the EC2 Transit Gateway |
| this\_ec2\_transit\_gateway\_propagation\_default\_route\_table\_id | Identifier of the default propagation route table |
| this\_ec2\_transit\_gateway\_route\_ids | List of EC2 Transit Gateway Route Table identifier combined with destination |
| this\_ec2\_transit\_gateway\_route\_table\_association | Map of EC2 Transit Gateway Route Table Association attributes |
| this\_ec2\_transit\_gateway\_route\_table\_association\_ids | List of EC2 Transit Gateway Route Table Association identifiers |
| this\_ec2\_transit\_gateway\_route\_table\_default\_association\_route\_table | Boolean whether this is the default association route table for the EC2 Transit Gateway |
| this\_ec2\_transit\_gateway\_route\_table\_default\_propagation\_route\_table | Boolean whether this is the default propagation route table for the EC2 Transit Gateway |
| this\_ec2\_transit\_gateway\_route\_table\_id | EC2 Transit Gateway Route Table identifier |
| this\_ec2\_transit\_gateway\_route\_table\_propagation | Map of EC2 Transit Gateway Route Table Propagation attributes |
| this\_ec2\_transit\_gateway\_route\_table\_propagation\_ids | List of EC2 Transit Gateway Route Table Propagation identifiers |
| this\_ec2\_transit\_gateway\_vpc\_attachment | Map of EC2 Transit Gateway VPC Attachment attributes |
| this\_ec2\_transit\_gateway\_vpc\_attachment\_ids | List of EC2 Transit Gateway VPC Attachment identifiers |
| this\_ram\_principal\_association\_id | The Amazon Resource Name (ARN) of the Resource Share and the principal, separated by a comma |
| this\_ram\_resource\_share\_id | The Amazon Resource Name (ARN) of the resource share |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module managed by [Anton Babenko](https://github.com/antonbabenko).

## License

Apache 2 Licensed. See LICENSE for full details.
