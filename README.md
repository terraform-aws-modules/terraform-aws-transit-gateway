# AWS Transit Gateway Terraform module

Terraform module which creates Transit Gateway resources on AWS.

## Usage with VPC module

```hcl
module "tgw" {
  source  = "terraform-aws-modules/transit-gateway/aws"

  name        = "my-tgw"
  description = "My TGW shared with several other AWS accounts"

  enable_auto_accept_shared_attachments = true

  vpc_attachments = {
    vpc = {
      vpc_id       = "vpc-1234556abcdef"
      subnet_ids   = ["subnet-abcde012", "subnet-bcde012a", "subnet-fghi345a"]
      dns_support  = true
      ipv6_support = true

      tgw_routes = [
        {
          destination_cidr_block = "30.0.0.0/16"
        },
        {
          blackhole              = true
          destination_cidr_block = "40.0.0.0/20"
        }
      ]
    }
  }

  ram_allow_external_principals = true
  ram_principals                = [307990089504]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
```

## Examples

- [Complete example](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/tree/master/examples/complete) shows TGW in combination with the [VPC module](https://github.com/terraform-aws-modules/terraform-aws-vpc) and [Resource Access Manager (RAM)](https://aws.amazon.com/ram/).
- [Multi-account example](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/tree/master/examples/multi-account) shows TGW resources shared with different AWS accounts (via [Resource Access Manager (RAM)](https://aws.amazon.com/ram/)).

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.5.7)

- <a name="requirement_aws"></a> [aws](#requirement\_aws) (>= 6.35)

## Providers

The following providers are used by this module:

- <a name="provider_aws"></a> [aws](#provider\_aws) (>= 6.35)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [aws_ec2_tag.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_tag) (resource)
- [aws_ec2_transit_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway) (resource)
- [aws_ec2_transit_gateway_route.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route) (resource)
- [aws_ec2_transit_gateway_route_table.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table) (resource)
- [aws_ec2_transit_gateway_route_table_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_association) (resource)
- [aws_ec2_transit_gateway_route_table_propagation.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_propagation) (resource)
- [aws_ec2_transit_gateway_vpc_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) (resource)
- [aws_ram_principal_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_principal_association) (resource)
- [aws_ram_resource_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_association) (resource)
- [aws_ram_resource_share.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_share) (resource)
- [aws_ram_resource_share_accepter.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_share_accepter) (resource)
- [aws_route.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) (resource)

## Required Inputs

No required inputs.

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_amazon_side_asn"></a> [amazon\_side\_asn](#input\_amazon\_side\_asn)

Description: The Autonomous System Number (ASN) for the Amazon side of the gateway. By default the TGW is created with the current default Amazon ASN.

Type: `string`

Default: `null`

### <a name="input_create_tgw"></a> [create\_tgw](#input\_create\_tgw)

Description: Controls if TGW should be created (it affects almost all resources)

Type: `bool`

Default: `true`

### <a name="input_create_tgw_routes"></a> [create\_tgw\_routes](#input\_create\_tgw\_routes)

Description: Controls if TGW Route Table / Routes should be created

Type: `bool`

Default: `true`

### <a name="input_description"></a> [description](#input\_description)

Description: Description of the EC2 Transit Gateway

Type: `string`

Default: `null`

### <a name="input_enable_auto_accept_shared_attachments"></a> [enable\_auto\_accept\_shared\_attachments](#input\_enable\_auto\_accept\_shared\_attachments)

Description: Whether resource attachment requests are automatically accepted

Type: `bool`

Default: `false`

### <a name="input_enable_default_route_table_association"></a> [enable\_default\_route\_table\_association](#input\_enable\_default\_route\_table\_association)

Description: Whether resource attachments are automatically associated with the default association route table

Type: `bool`

Default: `true`

### <a name="input_enable_default_route_table_propagation"></a> [enable\_default\_route\_table\_propagation](#input\_enable\_default\_route\_table\_propagation)

Description: Whether resource attachments automatically propagate routes to the default propagation route table

Type: `bool`

Default: `true`

### <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support)

Description: Should be true to enable DNS support in the TGW

Type: `bool`

Default: `true`

### <a name="input_enable_encryption_support"></a> [enable\_encryption\_support](#input\_enable\_encryption\_support)

Description: Should be true to enable encryption support in the TGW

Type: `bool`

Default: `false`

### <a name="input_enable_multicast_support"></a> [enable\_multicast\_support](#input\_enable\_multicast\_support)

Description: Whether multicast support is enabled

Type: `bool`

Default: `false`

### <a name="input_enable_sg_referencing_support"></a> [enable\_sg\_referencing\_support](#input\_enable\_sg\_referencing\_support)

Description: Indicates whether to enable security group referencing support

Type: `bool`

Default: `true`

### <a name="input_enable_vpn_ecmp_support"></a> [enable\_vpn\_ecmp\_support](#input\_enable\_vpn\_ecmp\_support)

Description: Whether VPN Equal Cost Multipath Protocol support is enabled

Type: `bool`

Default: `true`

### <a name="input_name"></a> [name](#input\_name)

Description: Name to be used on all the resources as identifier

Type: `string`

Default: `""`

### <a name="input_ram_allow_external_principals"></a> [ram\_allow\_external\_principals](#input\_ram\_allow\_external\_principals)

Description: Indicates whether principals outside your organization can be associated with a resource share.

Type: `bool`

Default: `false`

### <a name="input_ram_name"></a> [ram\_name](#input\_ram\_name)

Description: The name of the resource share of TGW

Type: `string`

Default: `""`

### <a name="input_ram_principals"></a> [ram\_principals](#input\_ram\_principals)

Description: A list of principals to share TGW with. Possible values are an AWS account ID, an AWS Organizations Organization ARN, or an AWS Organizations Organization Unit ARN

Type: `list(string)`

Default: `[]`

### <a name="input_ram_resource_share_arn"></a> [ram\_resource\_share\_arn](#input\_ram\_resource\_share\_arn)

Description: ARN of RAM resource share

Type: `string`

Default: `""`

### <a name="input_ram_resource_share_configuration"></a> [ram\_resource\_share\_configuration](#input\_ram\_resource\_share\_configuration)

Description: Resource share configuration for the RAM resource share. Set to control behavior when a principal account leaves the organization. Requires AWS provider >= 6.35.

Type:

```hcl
object({
    retain_sharing_on_account_leave_organization = optional(bool)
  })
```

Default: `null`

### <a name="input_ram_tags"></a> [ram\_tags](#input\_ram\_tags)

Description: Additional tags for the RAM

Type: `map(string)`

Default: `{}`

### <a name="input_region"></a> [region](#input\_region)

Description: Region where the resource(s) will be managed. Defaults to the region set in the provider configuration

Type: `string`

Default: `null`

### <a name="input_share_tgw"></a> [share\_tgw](#input\_share\_tgw)

Description: Whether to share your transit gateway with other accounts

Type: `bool`

Default: `true`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: A map of tags to add to all resources

Type: `map(string)`

Default: `{}`

### <a name="input_tgw_default_route_table_tags"></a> [tgw\_default\_route\_table\_tags](#input\_tgw\_default\_route\_table\_tags)

Description: Additional tags for the Default TGW route table

Type: `map(string)`

Default: `{}`

### <a name="input_tgw_route_table_tags"></a> [tgw\_route\_table\_tags](#input\_tgw\_route\_table\_tags)

Description: Additional tags for the TGW route table

Type: `map(string)`

Default: `{}`

### <a name="input_tgw_tags"></a> [tgw\_tags](#input\_tgw\_tags)

Description: Additional tags for the TGW

Type: `map(string)`

Default: `{}`

### <a name="input_tgw_vpc_attachment_tags"></a> [tgw\_vpc\_attachment\_tags](#input\_tgw\_vpc\_attachment\_tags)

Description: Additional tags for VPC attachments

Type: `map(string)`

Default: `{}`

### <a name="input_timeouts"></a> [timeouts](#input\_timeouts)

Description: Create, update, and delete timeout configurations for the transit gateway

Type:

```hcl
object({
    create = optional(string)
    update = optional(string)
    delete = optional(string)
  })
```

Default: `null`

### <a name="input_transit_gateway_cidr_blocks"></a> [transit\_gateway\_cidr\_blocks](#input\_transit\_gateway\_cidr\_blocks)

Description: One or more IPv4 or IPv6 CIDR blocks for the transit gateway. Must be a size /24 CIDR block or larger for IPv4, or a size /64 CIDR block or larger for IPv6

Type: `list(string)`

Default: `[]`

### <a name="input_transit_gateway_route_table_id"></a> [transit\_gateway\_route\_table\_id](#input\_transit\_gateway\_route\_table\_id)

Description: Identifier of EC2 Transit Gateway Route Table to use with the Target Gateway when reusing it between multiple TGWs

Type: `string`

Default: `null`

### <a name="input_vpc_attachments"></a> [vpc\_attachments](#input\_vpc\_attachments)

Description: Maps of maps of VPC details to attach to TGW. Type 'any' to disable type validation by Terraform.

Type: `any`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_ec2_transit_gateway_arn"></a> [ec2\_transit\_gateway\_arn](#output\_ec2\_transit\_gateway\_arn)

Description: EC2 Transit Gateway Amazon Resource Name (ARN)

### <a name="output_ec2_transit_gateway_association_default_route_table_id"></a> [ec2\_transit\_gateway\_association\_default\_route\_table\_id](#output\_ec2\_transit\_gateway\_association\_default\_route\_table\_id)

Description: Identifier of the default association route table

### <a name="output_ec2_transit_gateway_id"></a> [ec2\_transit\_gateway\_id](#output\_ec2\_transit\_gateway\_id)

Description: EC2 Transit Gateway identifier

### <a name="output_ec2_transit_gateway_owner_id"></a> [ec2\_transit\_gateway\_owner\_id](#output\_ec2\_transit\_gateway\_owner\_id)

Description: Identifier of the AWS account that owns the EC2 Transit Gateway

### <a name="output_ec2_transit_gateway_propagation_default_route_table_id"></a> [ec2\_transit\_gateway\_propagation\_default\_route\_table\_id](#output\_ec2\_transit\_gateway\_propagation\_default\_route\_table\_id)

Description: Identifier of the default propagation route table

### <a name="output_ec2_transit_gateway_route_ids"></a> [ec2\_transit\_gateway\_route\_ids](#output\_ec2\_transit\_gateway\_route\_ids)

Description: List of EC2 Transit Gateway Route Table identifier combined with destination

### <a name="output_ec2_transit_gateway_route_table_association"></a> [ec2\_transit\_gateway\_route\_table\_association](#output\_ec2\_transit\_gateway\_route\_table\_association)

Description: Map of EC2 Transit Gateway Route Table Association attributes

### <a name="output_ec2_transit_gateway_route_table_association_ids"></a> [ec2\_transit\_gateway\_route\_table\_association\_ids](#output\_ec2\_transit\_gateway\_route\_table\_association\_ids)

Description: List of EC2 Transit Gateway Route Table Association identifiers

### <a name="output_ec2_transit_gateway_route_table_default_association_route_table"></a> [ec2\_transit\_gateway\_route\_table\_default\_association\_route\_table](#output\_ec2\_transit\_gateway\_route\_table\_default\_association\_route\_table)

Description: Boolean whether this is the default association route table for the EC2 Transit Gateway

### <a name="output_ec2_transit_gateway_route_table_default_propagation_route_table"></a> [ec2\_transit\_gateway\_route\_table\_default\_propagation\_route\_table](#output\_ec2\_transit\_gateway\_route\_table\_default\_propagation\_route\_table)

Description: Boolean whether this is the default propagation route table for the EC2 Transit Gateway

### <a name="output_ec2_transit_gateway_route_table_id"></a> [ec2\_transit\_gateway\_route\_table\_id](#output\_ec2\_transit\_gateway\_route\_table\_id)

Description: EC2 Transit Gateway Route Table identifier

### <a name="output_ec2_transit_gateway_route_table_propagation"></a> [ec2\_transit\_gateway\_route\_table\_propagation](#output\_ec2\_transit\_gateway\_route\_table\_propagation)

Description: Map of EC2 Transit Gateway Route Table Propagation attributes

### <a name="output_ec2_transit_gateway_route_table_propagation_ids"></a> [ec2\_transit\_gateway\_route\_table\_propagation\_ids](#output\_ec2\_transit\_gateway\_route\_table\_propagation\_ids)

Description: List of EC2 Transit Gateway Route Table Propagation identifiers

### <a name="output_ec2_transit_gateway_vpc_attachment"></a> [ec2\_transit\_gateway\_vpc\_attachment](#output\_ec2\_transit\_gateway\_vpc\_attachment)

Description: Map of EC2 Transit Gateway VPC Attachment attributes

### <a name="output_ec2_transit_gateway_vpc_attachment_ids"></a> [ec2\_transit\_gateway\_vpc\_attachment\_ids](#output\_ec2\_transit\_gateway\_vpc\_attachment\_ids)

Description: List of EC2 Transit Gateway VPC Attachment identifiers

### <a name="output_ram_principal_association_id"></a> [ram\_principal\_association\_id](#output\_ram\_principal\_association\_id)

Description: The Amazon Resource Name (ARN) of the Resource Share and the principal, separated by a comma

### <a name="output_ram_resource_share_id"></a> [ram\_resource\_share\_id](#output\_ram\_resource\_share\_id)

Description: The Amazon Resource Name (ARN) of the resource share
<!-- END_TF_DOCS -->

## Authors

Module is maintained by [Anton Babenko](https://github.com/antonbabenko) with help from [these awesome contributors](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/graphs/contributors).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/tree/master/LICENSE) for full details.
