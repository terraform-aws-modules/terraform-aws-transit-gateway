# Complete AWS Transit Gateway example

Configuration in this directory creates AWS Transit Gateway, attach VPC to it and share it with other AWS principals using [Resource Access Manager (RAM)](https://aws.amazon.com/ram/).

## Notes

There is a famous limitation in Terraform which prevents us from using computed values in `count`. For this reason this example is using data-sources to discover already created default VPC and subnets.

In real-world scenario you will have to split creation of VPC (using [terraform-aws-vpc modules](https://github.com/terraform-aws-modules/terraform-aws-vpc)) and creation of TGW resources using this module. 

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

No input.

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
