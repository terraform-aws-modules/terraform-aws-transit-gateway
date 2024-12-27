# Complete AWS Transit Gateway example

Configuration in this directory creates AWS Transit Gateway, attach VPC to it and share it with other AWS principals using [Resource Access Manager (RAM)](https://aws.amazon.com/ram/).

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.78 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.78 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_s3_bucket"></a> [s3\_bucket](#module\_s3\_bucket) | terraform-aws-modules/s3-bucket/aws | ~> 3.0 |
| <a name="module_transit_gateway"></a> [transit\_gateway](#module\_transit\_gateway) | ../../ | n/a |
| <a name="module_transit_gateway_route_table"></a> [transit\_gateway\_route\_table](#module\_transit\_gateway\_route\_table) | ../../modules/route-table | n/a |
| <a name="module_vpc1"></a> [vpc1](#module\_vpc1) | terraform-aws-modules/vpc/aws | ~> 5.0 |
| <a name="module_vpc2"></a> [vpc2](#module\_vpc2) | terraform-aws-modules/vpc/aws | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| [random_pet.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.flow_log_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | EC2 Transit Gateway Amazon Resource Name (ARN) |
| <a name="output_association_default_route_table_id"></a> [association\_default\_route\_table\_id](#output\_association\_default\_route\_table\_id) | Identifier of the default association route table |
| <a name="output_id"></a> [id](#output\_id) | EC2 Transit Gateway identifier |
| <a name="output_owner_id"></a> [owner\_id](#output\_owner\_id) | Identifier of the AWS account that owns the EC2 Transit Gateway |
| <a name="output_peering_attachments"></a> [peering\_attachments](#output\_peering\_attachments) | Map of TGW peering attachments created |
| <a name="output_propagation_default_route_table_id"></a> [propagation\_default\_route\_table\_id](#output\_propagation\_default\_route\_table\_id) | Identifier of the default propagation route table |
| <a name="output_ram_resource_share_id"></a> [ram\_resource\_share\_id](#output\_ram\_resource\_share\_id) | The Amazon Resource Name (ARN) of the resource share |
| <a name="output_vpc_attachments"></a> [vpc\_attachments](#output\_vpc\_attachments) | Map of VPC attachments created |
<!-- END_TF_DOCS -->
