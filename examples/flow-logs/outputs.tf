################################################################################
# Transit Gateway Flow Logs - CloudWatch
################################################################################

output "tgw_flow_log_cloudwatch_id" {
  description = "CloudWatch flow log ID"
  value       = module.tgw_with_cloudwatch_logs.tgw_flow_log_id
}

output "tgw_flow_log_cloudwatch_destination_arn" {
  description = "CloudWatch flow log destination ARN"
  value       = module.tgw_with_cloudwatch_logs.tgw_flow_log_destination_arn
}

output "tgw_flow_log_cloudwatch_iam_role_arn" {
  description = "CloudWatch flow log IAM role ARN"
  value       = module.tgw_with_cloudwatch_logs.tgw_flow_log_cloudwatch_iam_role_arn
}

output "tgw_cloudwatch_id" {
  description = "CloudWatch TGW ID"
  value       = module.tgw_with_cloudwatch_logs.ec2_transit_gateway_id
}

################################################################################
# Transit Gateway Flow Logs - S3
################################################################################

output "tgw_flow_log_s3_id" {
  description = "S3 flow log ID"
  value       = module.tgw_with_s3_logs.tgw_flow_log_id
}

output "tgw_flow_log_s3_destination_arn" {
  description = "S3 flow log destination ARN"
  value       = module.tgw_with_s3_logs.tgw_flow_log_destination_arn
}

output "tgw_s3_id" {
  description = "S3 TGW ID"
  value       = module.tgw_with_s3_logs.ec2_transit_gateway_id
}

output "s3_bucket_name" {
  description = "S3 bucket name for flow logs"
  value       = aws_s3_bucket.flow_logs.bucket
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN for flow logs"
  value       = aws_s3_bucket.flow_logs.arn
}

################################################################################
# Transit Gateway Flow Logs - External Resources
################################################################################

output "tgw_flow_log_external_id" {
  description = "External resources flow log ID"
  value       = module.tgw_with_external_resources.tgw_flow_log_id
}

output "tgw_flow_log_external_destination_arn" {
  description = "External flow log destination ARN"
  value       = module.tgw_with_external_resources.tgw_flow_log_destination_arn
}

output "tgw_external_id" {
  description = "External TGW ID"
  value       = module.tgw_with_external_resources.ec2_transit_gateway_id
}

output "external_log_group_name" {
  description = "External CloudWatch log group name"
  value       = aws_cloudwatch_log_group.external.name
}

output "external_iam_role_arn" {
  description = "External IAM role ARN"
  value       = aws_iam_role.external.arn
}

################################################################################
# Supporting Resources
################################################################################

output "kms_key_id" {
  description = "KMS key ID for log encryption"
  value       = aws_kms_key.log_encryption.id
}

output "kms_key_arn" {
  description = "KMS key ARN for log encryption"
  value       = aws_kms_key.log_encryption.arn
}

output "vpc1_id" {
  description = "VPC1 ID"
  value       = module.vpc1.vpc_id
}

output "vpc2_id" {
  description = "VPC2 ID"
  value       = module.vpc2.vpc_id
}
