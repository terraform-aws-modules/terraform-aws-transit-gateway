################################################################################
# Flow Log - CloudWatch
################################################################################

output "cloudwatch_ec2_transit_gateway_id" {
  description = "EC2 Transit Gateway identifier"
  value       = module.tgw_flow_log_cloudwatch.ec2_transit_gateway_id
}

output "cloudwatch_ec2_transit_gateway_flow_log_id" {
  description = "The ID of the Transit Gateway Flow Log resource"
  value       = module.tgw_flow_log_cloudwatch.ec2_transit_gateway_flow_log_id
}

output "cloudwatch_ec2_transit_gateway_flow_log_destination_arn" {
  description = "The ARN of the destination for Transit Gateway Flow Logs"
  value       = module.tgw_flow_log_cloudwatch.ec2_transit_gateway_flow_log_destination_arn
}

output "cloudwatch_ec2_transit_gateway_flow_log_cloudwatch_iam_role_arn" {
  description = "The ARN of the IAM role used when pushing logs to Cloudwatch log group"
  value       = module.tgw_flow_log_cloudwatch.ec2_transit_gateway_flow_log_cloudwatch_iam_role_arn
}

output "cloudwatch_ec2_transit_gateway_flow_log_cloudwatch_log_group_name" {
  description = "The name of the CloudWatch log group created for Transit Gateway Flow Logs"
  value       = module.tgw_flow_log_cloudwatch.ec2_transit_gateway_flow_log_cloudwatch_log_group_name
}

################################################################################
# Flow Log - S3
################################################################################

output "s3_ec2_transit_gateway_id" {
  description = "EC2 Transit Gateway identifier"
  value       = module.tgw_flow_log_s3.ec2_transit_gateway_id
}

output "s3_ec2_transit_gateway_flow_log_id" {
  description = "The ID of the Transit Gateway Flow Log resource"
  value       = module.tgw_flow_log_s3.ec2_transit_gateway_flow_log_id
}

output "s3_ec2_transit_gateway_flow_log_destination_arn" {
  description = "The ARN of the destination for Transit Gateway Flow Logs"
  value       = module.tgw_flow_log_s3.ec2_transit_gateway_flow_log_destination_arn
}
