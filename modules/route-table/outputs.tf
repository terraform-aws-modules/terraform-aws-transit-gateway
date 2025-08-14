################################################################################
# Route Table
################################################################################

output "arn" {
  description = "EC2 Transit Gateway Route Table Amazon Resource Name (ARN)"
  value       = try(aws_ec2_transit_gateway_route_table.this[0].arn, null)
}

output "id" {
  description = "EC2 Transit Gateway Route Table identifier"
  value       = try(aws_ec2_transit_gateway_route_table.this[0].id, null)
}
