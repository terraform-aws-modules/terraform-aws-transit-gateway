# Complete AWS Transit Gateway example

Configuration in this directory creates AWS Transit Gateway, attach VPC to it and share it with other AWS principals using [Resource Access Manager (RAM)](https://aws.amazon.com/ram/) using provided map of transit route tables, routes and propagations.

## Notes

Tested in Terraform(v0.12.21) and Terragrunt(v0.22.5). This overcome the issue of limitation in Terraform which prevents us from using computed values in `count`. In other case needs to use some other solution for separation of creation VPCs and TGW and what is related to it.

Due to complexity / security concerns, VPN creation still had to be done outside of EC2 Transit Gateway module. It can be imported after of Transit Gateway's creation using `terraform import ...`. The names of resources to be imported can be found in `terraform plan ...` output. Just comment out all that is related to VPN for the first `terraform apply ...` in order to create TGW itself.

Overwise it should be developed using Customer Gateway that should be created ahead of launching the TGW module (not sure that it is worth to implement it).

There are implemented simple input parameters validations:

- if VPNs and VPCs logical names are unique (no vpn has the name of any VPC).
- if transit route tables map used in parallel with routes in variable vpc_attachments - which should not be used together.
- if routes are unique accross any single transit route table (no static route configured for different attachments or blackhole)
- each attachment is associated with exactly one transit route table

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

No provider.

## Inputs

No input.

## Outputs

| Name | Description |
|------|-------------|
| this\_ec2\_transit\_gateway\_arn | EC2 Transit Gateway Amazon Resource Name (ARN) |
| this\_ec2\_transit\_gateway\_id | EC2 Transit Gateway identifier |
| this\_ec2\_transit\_gateway\_owner\_id | Identifier of the AWS account that owns the EC2 Transit Gateway |
| this\_ec2\_transit\_gateway\_propagation\_default\_route\_table\_id | Identifier of the default propagation route table |
| this\_ec2\_transit\_gateway\_route\_ids | List of EC2 Transit Gateway Route Table identifier combined with destination |
| this\_ec2\_transit\_gateway\_route\_table\_default\_association\_route\_table | Boolean whether this is the default association route table for the EC2 Transit Gateway |
| this\_ec2\_transit\_gateway\_route\_table\_default\_propagation\_route\_table | Boolean whether this is the default propagation route table for the EC2 Transit Gateway |
| this\_ec2\_transit\_gateway\_route\_table\_id | EC2 Transit Gateway Route Table identifier |
| this\_ec2\_transit\_gateway\_vpc\_attachment | Map of EC2 Transit Gateway VPC Attachment attributes |
| this\_ec2\_transit\_gateway\_vpc\_attachment\_ids | List of EC2 Transit Gateway VPC Attachment identifiers |
| this\_ec2\_transit\_gateway\_vpn\_attachment\_ids | List of EC2 Transit Gateway VPN Attachment identifiers |
| this\_ram\_principal\_association\_id | The Amazon Resource Name (ARN) of the Resource Share and the principal, separated by a comma |
| this\_ram\_resource\_share\_id | The Amazon Resource Name (ARN) of the resource share |
| transit\_route\_tables\_map\_ec2\_transit\_gateway\_route\_table\_association | Map of EC2 Transit Gateway Route Table Association attributes using variable transit\_route\_tables\_map |
| transit\_route\_tables\_map\_ec2\_transit\_gateway\_route\_table\_association\_ids | List of EC2 Transit Gateway Route Table Association identifiers using variable transit\_route\_tables\_map |
| transit\_route\_tables\_map\_ec2\_transit\_gateway\_route\_table\_propagation | Map of EC2 Transit Gateway Route Table Propagation attributes using variable transit\_route\_tables\_map |
| transit\_route\_tables\_map\_ec2\_transit\_gateway\_route\_table\_propagation\_ids | List of EC2 Transit Gateway Route Table Propagation identifiers using variable transit\_route\_tables\_map |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
