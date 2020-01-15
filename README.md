# AWS Transit Gateway Terraform module

Terraform module which creates Transit Gateway resources on AWS.

This type of resources are supported:

* [Transit Gateway](https://www.terraform.io/docs/providers/aws/r/ec2_transit_gateway.html)
* [Transit Gateway Route](https://www.terraform.io/docs/providers/aws/r/ec2_transit_gateway_route.html)
* [Transit Gateway Route Table](https://www.terraform.io/docs/providers/aws/r/ec2_transit_gateway_route_table.html)
* [Transit Gateway Route Table Association](https://www.terraform.io/docs/providers/aws/r/ec2_transit_gateway_route_table_association.html)
* [Transit Gateway VPC Attachment](https://www.terraform.io/docs/providers/aws/r/ec2_transit_gateway_vpc_attachment.html)
* [Transit Gateway VPC Attachment Accepter](https://www.terraform.io/docs/providers/aws/r/ec2_transit_gateway_vpc_attachment_accepter.html)

## Terraform versions

Only Terraform 0.12 is supported.

## Usage with VPC module

```hcl
module "tgw" {
  source  = "terraform-aws-modules/transit-gateway/aws"
  version = "~> 1.0"
  
  description = "My TGW"
}
```

## Examples

* [Complete example](https://github.com/terraform-aws-modules/terraform-aws-transit-gateway/tree/master/examples/complete) shows TGW in combination with the [VPC module](https://github.com/terraform-aws-modules/terraform-aws-vpc).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| amazon\_side\_asn | The Autonomous System Number \(ASN\) for the Amazon side of the gateway. By default the TGW is created with the current default Amazon ASN. | string | `"64512"` | no |
| create\_tgw | Controls if TGW should be created \(it affects almost all resources\) | bool | `"true"` | no |
| create\_tgw\_route\_table | Controls if TGW Route Table should be created | bool | `"true"` | no |
| description | Description of the EC2 Transit Gateway | string | `"null"` | no |
| enable\_auto\_accept\_shared\_attachments | Whether resource attachment requests are automatically accepted | bool | `"false"` | no |
| enable\_default\_route\_table\_association | Whether resource attachments are automatically associated with the default association route table | bool | `"true"` | no |
| enable\_default\_route\_table\_propagation | Whether resource attachments automatically propagate routes to the default propagation route table | bool | `"true"` | no |
| enable\_dns\_support | Should be true to enable DNS support in the TGW | bool | `"true"` | no |
| enable\_vpn\_ecmp\_support | Whether VPN Equal Cost Multipath Protocol support is enabled | bool | `"true"` | no |
| name | Name to be used on all the resources as identifier | string | `""` | no |
| tags | A map of tags to add to all resources | map(string) | `{}` | no |
| tgw\_route\_table\_tags | Additional tags for the TGW route table | map(string) | `{}` | no |
| tgw\_tags | Additional tags for the TGW | map(string) | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| this\_ec2\_transit\_gateway\_arn | EC2 Transit Gateway Amazon Resource Name \(ARN\) |
| this\_ec2\_transit\_gateway\_association\_default\_route\_table\_id | Identifier of the default association route table |
| this\_ec2\_transit\_gateway\_id | EC2 Transit Gateway identifier |
| this\_ec2\_transit\_gateway\_owner\_id | Identifier of the AWS account that owns the EC2 Transit Gateway |
| this\_ec2\_transit\_gateway\_propagation\_default\_route\_table\_id | Identifier of the default propagation route table |
| this\_ec2\_transit\_gateway\_route\_table\_default\_association\_route\_table | Boolean whether this is the default association route table for the EC2 Transit Gateway |
| this\_ec2\_transit\_gateway\_route\_table\_default\_propagation\_route\_table | Boolean whether this is the default propagation route table for the EC2 Transit Gateway |
| this\_ec2\_transit\_gateway\_route\_table\_id | EC2 Transit Gateway Route Table identifier |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module managed by [Anton Babenko](https://github.com/antonbabenko).

## License

Apache 2 Licensed. See LICENSE for full details.
