# AWS Transit Gateway Flow Logs to S3 and CloudWatch Logs

Configuration in this directory creates Transit Gateways with Transit Gateway Flow Logs enabled in different configurations:

- Flow log to CloudWatch Logs using module created CloudWatch log group and IAM role
- Flow log to S3 bucket in Parquet format with Hive compatible, per hour partitions

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
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.28 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.28 |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_s3_bucket"></a> [s3\_bucket](#module\_s3\_bucket) | terraform-aws-modules/s3-bucket/aws | ~> 5.0 |
| <a name="module_tgw_flow_log_cloudwatch"></a> [tgw\_flow\_log\_cloudwatch](#module\_tgw\_flow\_log\_cloudwatch) | ../../ | n/a |
| <a name="module_tgw_flow_log_s3"></a> [tgw\_flow\_log\_s3](#module\_tgw\_flow\_log\_s3) | ../../ | n/a |

## Resources

| Name | Type |
| ---- | ---- |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_cloudwatch_ec2_transit_gateway_flow_log_cloudwatch_iam_role_arn"></a> [cloudwatch\_ec2\_transit\_gateway\_flow\_log\_cloudwatch\_iam\_role\_arn](#output\_cloudwatch\_ec2\_transit\_gateway\_flow\_log\_cloudwatch\_iam\_role\_arn) | The ARN of the IAM role used when pushing logs to Cloudwatch log group |
| <a name="output_cloudwatch_ec2_transit_gateway_flow_log_cloudwatch_log_group_name"></a> [cloudwatch\_ec2\_transit\_gateway\_flow\_log\_cloudwatch\_log\_group\_name](#output\_cloudwatch\_ec2\_transit\_gateway\_flow\_log\_cloudwatch\_log\_group\_name) | The name of the CloudWatch log group created for Transit Gateway Flow Logs |
| <a name="output_cloudwatch_ec2_transit_gateway_flow_log_destination_arn"></a> [cloudwatch\_ec2\_transit\_gateway\_flow\_log\_destination\_arn](#output\_cloudwatch\_ec2\_transit\_gateway\_flow\_log\_destination\_arn) | The ARN of the destination for Transit Gateway Flow Logs |
| <a name="output_cloudwatch_ec2_transit_gateway_flow_log_id"></a> [cloudwatch\_ec2\_transit\_gateway\_flow\_log\_id](#output\_cloudwatch\_ec2\_transit\_gateway\_flow\_log\_id) | The ID of the Transit Gateway Flow Log resource |
| <a name="output_cloudwatch_ec2_transit_gateway_id"></a> [cloudwatch\_ec2\_transit\_gateway\_id](#output\_cloudwatch\_ec2\_transit\_gateway\_id) | EC2 Transit Gateway identifier |
| <a name="output_s3_ec2_transit_gateway_flow_log_destination_arn"></a> [s3\_ec2\_transit\_gateway\_flow\_log\_destination\_arn](#output\_s3\_ec2\_transit\_gateway\_flow\_log\_destination\_arn) | The ARN of the destination for Transit Gateway Flow Logs |
| <a name="output_s3_ec2_transit_gateway_flow_log_id"></a> [s3\_ec2\_transit\_gateway\_flow\_log\_id](#output\_s3\_ec2\_transit\_gateway\_flow\_log\_id) | The ID of the Transit Gateway Flow Log resource |
| <a name="output_s3_ec2_transit_gateway_id"></a> [s3\_ec2\_transit\_gateway\_id](#output\_s3\_ec2\_transit\_gateway\_id) | EC2 Transit Gateway identifier |
<!-- END_TF_DOCS -->
