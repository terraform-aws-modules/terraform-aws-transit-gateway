# Complete AWS Transit Gateway example

Configuration in this directory creates AWS Transit Gateway and attach VPC to it.

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
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
