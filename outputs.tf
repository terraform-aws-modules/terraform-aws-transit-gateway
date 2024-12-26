################################################################################
# Transit Gateway
################################################################################

output "arn" {
  description = "EC2 Transit Gateway Amazon Resource Name (ARN)"
  value       = try(aws_ec2_transit_gateway.this[0].arn, null)
}

output "id" {
  description = "EC2 Transit Gateway identifier"
  value       = try(aws_ec2_transit_gateway.this[0].id, null)
}

output "owner_id" {
  description = "Identifier of the AWS account that owns the EC2 Transit Gateway"
  value       = try(aws_ec2_transit_gateway.this[0].owner_id, null)
}

output "association_default_route_table_id" {
  description = "Identifier of the default association route table"
  value       = try(aws_ec2_transit_gateway.this[0].association_default_route_table_id, null)
}

output "propagation_default_route_table_id" {
  description = "Identifier of the default propagation route table"
  value       = try(aws_ec2_transit_gateway.this[0].propagation_default_route_table_id, null)
}

################################################################################
# Resource Access Manager
################################################################################

output "ram_resource_share_id" {
  description = "The Amazon Resource Name (ARN) of the resource share"
  value       = try(aws_ram_resource_share.this[0].id, null)
}
