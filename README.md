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
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.23 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.23 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.tgw_flow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ec2_tag.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_tag) | resource |
| [aws_ec2_transit_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway) | resource |
| [aws_ec2_transit_gateway_route.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route) | resource |
| [aws_ec2_transit_gateway_route_table.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table) | resource |
| [aws_ec2_transit_gateway_route_table_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_association) | resource |
| [aws_ec2_transit_gateway_route_table_propagation.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_propagation) | resource |
| [aws_ec2_transit_gateway_vpc_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_flow_log.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_iam_policy.tgw_flow_log_cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.tgw_flow_log_cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.tgw_flow_log_cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_ram_principal_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_principal_association) | resource |
| [aws_ram_resource_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_association) | resource |
| [aws_ram_resource_share.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_share) | resource |
| [aws_ram_resource_share_accepter.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_share_accepter) | resource |
| [aws_route.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_iam_policy_document.tgw_flow_log_cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.tgw_flow_log_cloudwatch_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_amazon_side_asn"></a> [amazon\_side\_asn](#input\_amazon\_side\_asn) | The Autonomous System Number (ASN) for the Amazon side of the gateway. By default the TGW is created with the current default Amazon ASN. | `string` | `null` | no |
| <a name="input_create_flow_log_cloudwatch_iam_role"></a> [create\_flow\_log\_cloudwatch\_iam\_role](#input\_create\_flow\_log\_cloudwatch\_iam\_role) | (Optional) Whether to create IAM role for Transit Gateway Flow Logs. | `bool` | `false` | no |
| <a name="input_create_flow_log_cloudwatch_log_group"></a> [create\_flow\_log\_cloudwatch\_log\_group](#input\_create\_flow\_log\_cloudwatch\_log\_group) | (Optional) Whether to create CloudWatch log group for Transit Gateway Flow Logs. | `bool` | `false` | no |
| <a name="input_create_tgw"></a> [create\_tgw](#input\_create\_tgw) | Controls if TGW should be created (it affects almost all resources) | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the EC2 Transit Gateway | `string` | `null` | no |
| <a name="input_enable_auto_accept_shared_attachments"></a> [enable\_auto\_accept\_shared\_attachments](#input\_enable\_auto\_accept\_shared\_attachments) | Whether resource attachment requests are automatically accepted | `bool` | `false` | no |
| <a name="input_enable_default_route_table_association"></a> [enable\_default\_route\_table\_association](#input\_enable\_default\_route\_table\_association) | Whether resource attachments are automatically associated with the default association route table | `bool` | `true` | no |
| <a name="input_enable_default_route_table_propagation"></a> [enable\_default\_route\_table\_propagation](#input\_enable\_default\_route\_table\_propagation) | Whether resource attachments automatically propagate routes to the default propagation route table | `bool` | `true` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | Should be true to enable DNS support in the TGW | `bool` | `true` | no |
| <a name="input_enable_flow_log"></a> [enable\_flow\_log](#input\_enable\_flow\_log) | (Optional) Whether or not to enable Transit Gateway Flow Logs. | `bool` | `false` | no |
| <a name="input_enable_mutlicast_support"></a> [enable\_mutlicast\_support](#input\_enable\_mutlicast\_support) | Whether multicast support is enabled | `bool` | `false` | no |
| <a name="input_enable_vpn_ecmp_support"></a> [enable\_vpn\_ecmp\_support](#input\_enable\_vpn\_ecmp\_support) | Whether VPN Equal Cost Multipath Protocol support is enabled | `bool` | `true` | no |
| <a name="input_flow_log_cloudwatch_iam_role_arn"></a> [flow\_log\_cloudwatch\_iam\_role\_arn](#input\_flow\_log\_cloudwatch\_iam\_role\_arn) | The ARN for the IAM role that's used to post flow logs to a CloudWatch Logs log group. When flow\_log\_destination\_arn is set to ARN of Cloudwatch Logs, this argument needs to be provided. | `string` | `""` | no |
| <a name="input_flow_log_cloudwatch_iam_role_permissions_boundary"></a> [flow\_log\_cloudwatch\_iam\_role\_permissions\_boundary](#input\_flow\_log\_cloudwatch\_iam\_role\_permissions\_boundary) | (Optional) The ARN of the Permissions Boundary for the Transit Gateway Flow Log IAM Role | `string` | `null` | no |
| <a name="input_flow_log_cloudwatch_log_group_kms_key_id"></a> [flow\_log\_cloudwatch\_log\_group\_kms\_key\_id](#input\_flow\_log\_cloudwatch\_log\_group\_kms\_key\_id) | (Optional) The ARN of the KMS Key to use when encrypting log data for Transit Gateway flow logs. | `string` | `null` | no |
| <a name="input_flow_log_cloudwatch_log_group_name_prefix"></a> [flow\_log\_cloudwatch\_log\_group\_name\_prefix](#input\_flow\_log\_cloudwatch\_log\_group\_name\_prefix) | (Optional) Specifies the name prefix of CloudWatch Log Group for Transit Gateway flow logs. | `string` | `"/aws/tgw-flow-log/"` | no |
| <a name="input_flow_log_cloudwatch_log_group_retention_in_days"></a> [flow\_log\_cloudwatch\_log\_group\_retention\_in\_days](#input\_flow\_log\_cloudwatch\_log\_group\_retention\_in\_days) | (Optional) Specifies the number of days you want to retain log events in the specified log group for Transit Gateway flow logs. | `number` | `null` | no |
| <a name="input_flow_log_destination_arn"></a> [flow\_log\_destination\_arn](#input\_flow\_log\_destination\_arn) | The ARN of the CloudWatch log group or S3 bucket where Transit Gateway Flow Logs will be pushed. If this ARN is a S3 bucket the appropriate permissions need to be set on that bucket's policy. When create\_flow\_log\_cloudwatch\_log\_group is set to false this argument must be provided. | `string` | `""` | no |
| <a name="input_flow_log_destination_type"></a> [flow\_log\_destination\_type](#input\_flow\_log\_destination\_type) | (Optional) Type of flow log destination. Can be s3 or cloud-watch-logs. | `string` | `"cloud-watch-logs"` | no |
| <a name="input_flow_log_file_format"></a> [flow\_log\_file\_format](#input\_flow\_log\_file\_format) | (Optional) The format for the flow log. Valid values: `plain-text`, `parquet`. | `string` | `"plain-text"` | no |
| <a name="input_flow_log_hive_compatible_partitions"></a> [flow\_log\_hive\_compatible\_partitions](#input\_flow\_log\_hive\_compatible\_partitions) | (Optional) Indicates whether to use Hive-compatible prefixes for flow logs stored in Amazon S3. | `bool` | `false` | no |
| <a name="input_flow_log_log_format"></a> [flow\_log\_log\_format](#input\_flow\_log\_log\_format) | (Optional) The fields to include in the flow log record, in the order in which they should appear. | `string` | `null` | no |
| <a name="input_flow_log_per_hour_partition"></a> [flow\_log\_per\_hour\_partition](#input\_flow\_log\_per\_hour\_partition) | (Optional) Indicates whether to partition the flow log per hour. This reduces the cost and response time for queries. | `bool` | `false` | no |
| <a name="input_flow_log_tags"></a> [flow\_log\_tags](#input\_flow\_log\_tags) | (Optional) Additional tags for the Transit Gateway Flow Logs | `map(string)` | `{}` | no |
| <a name="input_flow_log_traffic_type"></a> [flow\_log\_traffic\_type](#input\_flow\_log\_traffic\_type) | (Optional) The type of traffic to capture. Valid values: ACCEPT,REJECT, ALL. | `string` | `"ALL"` | no |
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
