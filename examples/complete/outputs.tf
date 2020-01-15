output "this_ec2_transit_gateway_arn" {
  description = "EC2 Transit Gateway Amazon Resource Name (ARN)"
  value       = module.tgw.this_ec2_transit_gateway_arn
}

output "this_ec2_transit_gateway_association_default_route_table_id" {
  description = "Identifier of the default association route table"
  value       = module.tgw.this_ec2_transit_gateway_association_default_route_table_id
}

output "this_ec2_transit_gateway_id" {
  description = "EC2 Transit Gateway identifier"
  value       = module.tgw.this_ec2_transit_gateway_id
}

output "this_ec2_transit_gateway_owner_id" {
  description = "Identifier of the AWS account that owns the EC2 Transit Gateway"
  value       = module.tgw.this_ec2_transit_gateway_owner_id
}

output "this_ec2_transit_gateway_propagation_default_route_table_id" {
  description = "Identifier of the default propagation route table"
  value       = module.tgw.this_ec2_transit_gateway_propagation_default_route_table_id
}

output "this_ec2_transit_gateway_route_table_default_association_route_table" {
  description = "Boolean whether this is the default association route table for the EC2 Transit Gateway"
  value       = module.tgw.this_ec2_transit_gateway_route_table_default_association_route_table
}

output "this_ec2_transit_gateway_route_table_default_propagation_route_table" {
  description = "Boolean whether this is the default propagation route table for the EC2 Transit Gateway"
  value       = module.tgw.this_ec2_transit_gateway_route_table_default_propagation_route_table
}

output "this_ec2_transit_gateway_route_table_id" {
  description = "EC2 Transit Gateway Route Table identifier"
  value       = module.tgw.this_ec2_transit_gateway_route_table_id
}
