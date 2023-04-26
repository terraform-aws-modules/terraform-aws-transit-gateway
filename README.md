# AWS Transit Gateway Terraform module

Terraform module which creates Transit Gateway resources on AWS.

## Usage with VPC module

```hcl
module "tgw" {
  source  = "terraform-aws-modules/transit-gateway/aws"
  version = "~> 2.0"

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
  version = "~> 3.0"

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

- [Complete example](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/tree/master/examples/complete) shows TGW in combination with the [VPC module](https://github.com/terraform-aws-modules/terraform-aws-vpc) and [Resource Access Manager (RAM)](https://aws.amazon.com/ram/).
- [Multi-account example](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/tree/master/examples/multi-account) shows TGW resources shared with different AWS accounts (via [Resource Access Manager (RAM)](https://aws.amazon.com/ram/)).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.4 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ec2_tag.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_tag) | resource |
| [aws_ec2_transit_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway) | resource |
| [aws_ec2_transit_gateway_route.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route) | resource |
| [aws_ec2_transit_gateway_route_table.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table) | resource |
| [aws_ec2_transit_gateway_route_table_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_association) | resource |
| [aws_ec2_transit_gateway_route_table_propagation.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_propagation) | resource |
| [aws_ec2_transit_gateway_vpc_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_ram_principal_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_principal_association) | resource |
| [aws_ram_resource_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_association) | resource |
| [aws_ram_resource_share.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_share) | resource |
| [aws_ram_resource_share_accepter.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_share_accepter) | resource |
| [aws_route.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_amazon_side_asn"></a> [amazon\_side\_asn](#input\_amazon\_side\_asn) | The Autonomous System Number (ASN) for the Amazon side of the gateway. By default the TGW is created with the current default Amazon ASN. | `string` | `null` | no |
| <a name="input_create_tgw"></a> [create\_tgw](#input\_create\_tgw) | Controls if TGW should be created (it affects almost all resources) | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the EC2 Transit Gateway | `string` | `null` | no |
| <a name="input_enable_auto_accept_shared_attachments"></a> [enable\_auto\_accept\_shared\_attachments](#input\_enable\_auto\_accept\_shared\_attachments) | Whether resource attachment requests are automatically accepted | `bool` | `false` | no |
| <a name="input_enable_default_route_table_association"></a> [enable\_default\_route\_table\_association](#input\_enable\_default\_route\_table\_association) | Whether resource attachments are automatically associated with the default association route table | `bool` | `true` | no |
| <a name="input_enable_default_route_table_propagation"></a> [enable\_default\_route\_table\_propagation](#input\_enable\_default\_route\_table\_propagation) | Whether resource attachments automatically propagate routes to the default propagation route table | `bool` | `true` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | Should be true to enable DNS support in the TGW | `bool` | `true` | no |
| <a name="input_enable_multicast_support"></a> [enable\_multicast\_support](#input\_enable\_multicast\_support) | Whether multicast support is enabled | `bool` | `false` | no |
| <a name="input_enable_vpn_ecmp_support"></a> [enable\_vpn\_ecmp\_support](#input\_enable\_vpn\_ecmp\_support) | Whether VPN Equal Cost Multipath Protocol support is enabled | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | Name to be used on all the resources as identifier | `string` | `""` | no |
| <a name="input_ram_allow_external_principals"></a> [ram\_allow\_external\_principals](#input\_ram\_allow\_external\_principals) | Indicates whether principals outside your organization can be associated with a resource share. | `bool` | `false` | no |
| <a name="input_ram_name"></a> [ram\_name](#input\_ram\_name) | The name of the resource share of TGW | `string` | `""` | no |
| <a name="input_ram_principals"></a> [ram\_principals](#input\_ram\_principals) | A list of principals to share TGW with. Possible values are an AWS account ID, an AWS Organizations Organization ARN, or an AWS Organizations Organization Unit ARN | `list(string)` | `[]` | no |
| <a name="input_ram_resource_share_arn"></a> [ram\_resource\_share\_arn](#input\_ram\_resource\_share\_arn) | ARN of RAM resource share | `string` | `""` | no |
| <a name="input_ram_tags"></a> [ram\_tags](#input\_ram\_tags) | Additional tags for the RAM | `map(string)` | `{}` | no |
| <a name="input_share_tgw"></a> [share\_tgw](#input\_share\_tgw) | Whether to share your transit gateway with other accounts | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_tgw_default_route_table_tags"></a> [tgw\_default\_route\_table\_tags](#input\_tgw\_default\_route\_table\_tags) | Additional tags for the Default TGW route table | `map(string)` | `{}` | no |
| <a name="input_tgw_route_table_tags"></a> [tgw\_route\_table\_tags](#input\_tgw\_route\_table\_tags) | Additional tags for the TGW route table | `map(string)` | `{}` | no |
| <a name="input_tgw_tags"></a> [tgw\_tags](#input\_tgw\_tags) | Additional tags for the TGW | `map(string)` | `{}` | no |
| <a name="input_tgw_vpc_attachment_tags"></a> [tgw\_vpc\_attachment\_tags](#input\_tgw\_vpc\_attachment\_tags) | Additional tags for VPC attachments | `map(string)` | `{}` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | Create, update, and delete timeout configurations for the transit gateway | `map(string)` | `{}` | no |
| <a name="input_transit_gateway_cidr_blocks"></a> [transit\_gateway\_cidr\_blocks](#input\_transit\_gateway\_cidr\_blocks) | One or more IPv4 or IPv6 CIDR blocks for the transit gateway. Must be a size /24 CIDR block or larger for IPv4, or a size /64 CIDR block or larger for IPv6 | `list(string)` | `[]` | no |
| <a name="input_transit_gateway_route_table_id"></a> [transit\_gateway\_route\_table\_id](#input\_transit\_gateway\_route\_table\_id) | Identifier of EC2 Transit Gateway Route Table to use with the Target Gateway when reusing it between multiple TGWs | `string` | `null` | no |
| <a name="input_vpc_attachments"></a> [vpc\_attachments](#input\_vpc\_attachments) | Maps of maps of VPC details to attach to TGW. Type 'any' to disable type validation by Terraform. | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ec2_transit_gateway_arn"></a> [ec2\_transit\_gateway\_arn](#output\_ec2\_transit\_gateway\_arn) | EC2 Transit Gateway Amazon Resource Name (ARN) |
| <a name="output_ec2_transit_gateway_association_default_route_table_id"></a> [ec2\_transit\_gateway\_association\_default\_route\_table\_id](#output\_ec2\_transit\_gateway\_association\_default\_route\_table\_id) | Identifier of the default association route table |
| <a name="output_ec2_transit_gateway_id"></a> [ec2\_transit\_gateway\_id](#output\_ec2\_transit\_gateway\_id) | EC2 Transit Gateway identifier |
| <a name="output_ec2_transit_gateway_owner_id"></a> [ec2\_transit\_gateway\_owner\_id](#output\_ec2\_transit\_gateway\_owner\_id) | Identifier of the AWS account that owns the EC2 Transit Gateway |
| <a name="output_ec2_transit_gateway_propagation_default_route_table_id"></a> [ec2\_transit\_gateway\_propagation\_default\_route\_table\_id](#output\_ec2\_transit\_gateway\_propagation\_default\_route\_table\_id) | Identifier of the default propagation route table |
| <a name="output_ec2_transit_gateway_route_ids"></a> [ec2\_transit\_gateway\_route\_ids](#output\_ec2\_transit\_gateway\_route\_ids) | List of EC2 Transit Gateway Route Table identifier combined with destination |
| <a name="output_ec2_transit_gateway_route_table_association"></a> [ec2\_transit\_gateway\_route\_table\_association](#output\_ec2\_transit\_gateway\_route\_table\_association) | Map of EC2 Transit Gateway Route Table Association attributes |
| <a name="output_ec2_transit_gateway_route_table_association_ids"></a> [ec2\_transit\_gateway\_route\_table\_association\_ids](#output\_ec2\_transit\_gateway\_route\_table\_association\_ids) | List of EC2 Transit Gateway Route Table Association identifiers |
| <a name="output_ec2_transit_gateway_route_table_default_association_route_table"></a> [ec2\_transit\_gateway\_route\_table\_default\_association\_route\_table](#output\_ec2\_transit\_gateway\_route\_table\_default\_association\_route\_table) | Boolean whether this is the default association route table for the EC2 Transit Gateway |
| <a name="output_ec2_transit_gateway_route_table_default_propagation_route_table"></a> [ec2\_transit\_gateway\_route\_table\_default\_propagation\_route\_table](#output\_ec2\_transit\_gateway\_route\_table\_default\_propagation\_route\_table) | Boolean whether this is the default propagation route table for the EC2 Transit Gateway |
| <a name="output_ec2_transit_gateway_route_table_id"></a> [ec2\_transit\_gateway\_route\_table\_id](#output\_ec2\_transit\_gateway\_route\_table\_id) | EC2 Transit Gateway Route Table identifier |
| <a name="output_ec2_transit_gateway_route_table_propagation"></a> [ec2\_transit\_gateway\_route\_table\_propagation](#output\_ec2\_transit\_gateway\_route\_table\_propagation) | Map of EC2 Transit Gateway Route Table Propagation attributes |
| <a name="output_ec2_transit_gateway_route_table_propagation_ids"></a> [ec2\_transit\_gateway\_route\_table\_propagation\_ids](#output\_ec2\_transit\_gateway\_route\_table\_propagation\_ids) | List of EC2 Transit Gateway Route Table Propagation identifiers |
| <a name="output_ec2_transit_gateway_vpc_attachment"></a> [ec2\_transit\_gateway\_vpc\_attachment](#output\_ec2\_transit\_gateway\_vpc\_attachment) | Map of EC2 Transit Gateway VPC Attachment attributes |
| <a name="output_ec2_transit_gateway_vpc_attachment_ids"></a> [ec2\_transit\_gateway\_vpc\_attachment\_ids](#output\_ec2\_transit\_gateway\_vpc\_attachment\_ids) | List of EC2 Transit Gateway VPC Attachment identifiers |
| <a name="output_ram_principal_association_id"></a> [ram\_principal\_association\_id](#output\_ram\_principal\_association\_id) | The Amazon Resource Name (ARN) of the Resource Share and the principal, separated by a comma |
| <a name="output_ram_resource_share_id"></a> [ram\_resource\_share\_id](#output\_ram\_resource\_share\_id) | The Amazon Resource Name (ARN) of the resource share |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module is maintained by [Anton Babenko](https://github.com/antonbabenko) with help from [these awesome contributors](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/graphs/contributors).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/tree/master/LICENSE) for full details.
