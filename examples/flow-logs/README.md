# Transit Gateway Flow Logs Example

This example demonstrates how to configure Transit Gateway Flow Logs with various destination options.

## Features

This example shows how to:

- Enable Transit Gateway Flow Logs to CloudWatch Logs
- Configure custom log format and retention
- Set up S3 destination for flow logs
- Use external CloudWatch Log Group and IAM role
- Configure flow log aggregation intervals

## Usage

To run this example, you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which will incur monetary charges on your AWS bill. Run `terraform destroy` when you no longer need these resources.

## Flow Log Destinations

### CloudWatch Logs (Default)

Flow logs are sent to CloudWatch Logs with automatic IAM role and log group creation:

```hcl
module "tgw_with_cloudwatch_logs" {
  source = "../../"

  name        = "tgw-flow-logs-cloudwatch"
  description = "TGW with CloudWatch flow logs"

  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true

  # CloudWatch specific settings
  flow_log_cloudwatch_log_group_retention_in_days = 30
  flow_log_cloudwatch_log_group_kms_key_id        = aws_kms_key.log_encryption.arn

  # Traffic settings
  flow_log_traffic_type             = "ALL"
  flow_log_max_aggregation_interval = 60

  vpc_attachments = {
    vpc = {
      vpc_id     = module.vpc.vpc_id
      subnet_ids = module.vpc.private_subnets
    }
  }

  tags = local.tags
}
```

### S3 Destination

Flow logs are sent to S3 bucket with Parquet format:

```hcl
module "tgw_with_s3_logs" {
  source = "../../"

  name        = "tgw-flow-logs-s3"
  description = "TGW with S3 flow logs"

  enable_flow_log           = true
  flow_log_destination_type = "s3"
  flow_log_destination_arn  = aws_s3_bucket.flow_logs.arn

  # S3 specific settings
  flow_log_file_format                = "parquet"
  flow_log_hive_compatible_partitions = true
  flow_log_per_hour_partition         = true

  vpc_attachments = {
    vpc = {
      vpc_id     = module.vpc.vpc_id
      subnet_ids = module.vpc.private_subnets
    }
  }

  tags = local.tags
}
```

### External Resources

Using existing CloudWatch Log Group and IAM role:

```hcl
module "tgw_with_external_resources" {
  source = "../../"

  name        = "tgw-flow-logs-external"
  description = "TGW with external flow log resources"

  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = false
  create_flow_log_cloudwatch_iam_role  = false

  flow_log_destination_arn           = aws_cloudwatch_log_group.external.arn
  flow_log_cloudwatch_iam_role_arn   = aws_iam_role.external.arn

  vpc_attachments = {
    vpc = {
      vpc_id     = module.vpc.vpc_id
      subnet_ids = module.vpc.private_subnets
    }
  }

  tags = local.tags
}
```

## Custom Log Format

You can specify a custom log format to capture specific fields:

```hcl
# Custom log format with specific fields
flow_log_log_format = "$${version} $${account-id} $${transit-gateway-id} $${transit-gateway-attachment-id} $${srcaddr} $${dstaddr} $${srcport} $${dstport} $${protocol} $${packets} $${bytes} $${windowstart} $${windowend} $${action}"
```

Available fields for Transit Gateway Flow Logs:
- `version` - VPC Flow Logs version
- `account-id` - AWS account ID
- `transit-gateway-id` - Transit Gateway ID
- `transit-gateway-attachment-id` - Transit Gateway attachment ID
- `srcaddr` - Source address
- `dstaddr` - Destination address
- `srcport` - Source port
- `dstport` - Destination port
- `protocol` - IANA protocol number
- `packets` - Number of packets transferred
- `bytes` - Number of bytes transferred
- `windowstart` - Start time of the aggregation interval
- `windowend` - End time of the aggregation interval
- `action` - Action that is associated with the traffic (ACCEPT or REJECT)

## Security Considerations

- Flow logs may contain sensitive network information
- Use KMS encryption for CloudWatch Logs
- Implement proper S3 bucket policies for S3 destinations
- Consider log retention policies to manage costs
- Use IAM policies to restrict access to flow log data

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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tgw_with_cloudwatch_logs"></a> [tgw\_with\_cloudwatch\_logs](#module\_tgw\_with\_cloudwatch\_logs) | ../../ | n/a |
| <a name="module_tgw_with_s3_logs"></a> [tgw\_with\_s3\_logs](#module\_tgw\_with\_s3\_logs) | ../../ | n/a |
| <a name="module_tgw_with_external_resources"></a> [tgw\_with\_external\_resources](#module\_tgw\_with\_external\_resources) | ../../ | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.external](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.external](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_kms_key.log_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tgw_flow_log_cloudwatch_id"></a> [tgw\_flow\_log\_cloudwatch\_id](#output\_tgw\_flow\_log\_cloudwatch\_id) | CloudWatch flow log ID |
| <a name="output_tgw_flow_log_s3_id"></a> [tgw\_flow\_log\_s3\_id](#output\_tgw\_flow\_log\_s3\_id) | S3 flow log ID |
| <a name="output_tgw_flow_log_external_id"></a> [tgw\_flow\_log\_external\_id](#output\_tgw\_flow\_log\_external\_id) | External resources flow log ID |
