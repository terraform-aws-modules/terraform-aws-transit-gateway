// aws_ec2_transit_gateway
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

// aws_ec2_transit_gateway_route_table
output "this_ec2_transit_gateway_route_table_id" {
  description = "EC2 Transit Gateway Route Table identifier"
  value       = module.tgw.this_ec2_transit_gateway_route_table_id
}

// aws_ec2_transit_gateway_route
output "this_ec2_transit_gateway_route_ids" {
  description = "List of EC2 Transit Gateway Route Table identifier combined with destination"
  value       = module.tgw.this_ec2_transit_gateway_route_ids
}

// aws_ec2_transit_gateway_vpc_attachment
output "this_ec2_transit_gateway_vpc_attachment_ids" {
  description = "List of EC2 Transit Gateway VPC Attachment identifiers"
  value       = module.tgw.this_ec2_transit_gateway_vpc_attachment_ids
}

output "this_ec2_transit_gateway_vpc_attachment" {
  description = "Map of EC2 Transit Gateway VPC Attachment attributes"
  value       = module.tgw.this_ec2_transit_gateway_vpc_attachment
}

// aws_ec2_transit_gateway_route_table_association
output "this_ec2_transit_gateway_route_table_association_ids" {
  description = "List of EC2 Transit Gateway Route Table Association identifiers"
  value       = module.tgw.this_ec2_transit_gateway_route_table_association_ids
}

output "this_ec2_transit_gateway_route_table_association" {
  description = "Map of EC2 Transit Gateway Route Table Association attributes"
  value       = module.tgw.this_ec2_transit_gateway_route_table_association
}

// aws_ec2_transit_gateway_route_table_propagation
output "this_ec2_transit_gateway_route_table_propagation_ids" {
  description = "List of EC2 Transit Gateway Route Table Propagation identifiers"
  value       = module.tgw.this_ec2_transit_gateway_route_table_propagation_ids
}

output "this_ec2_transit_gateway_route_table_propagation" {
  description = "Map of EC2 Transit Gateway Route Table Propagation attributes"
  value       = module.tgw.this_ec2_transit_gateway_route_table_propagation
}

// aws_ram_resource_share
output "this_ram_resource_share_id" {
  description = "The Amazon Resource Name (ARN) of the resource share"
  value       = module.tgw.this_ram_resource_share_id
}

// aws_ram_principal_association
output "this_ram_principal_association_id" {
  description = "The Amazon Resource Name (ARN) of the Resource Share and the principal, separated by a comma"
  value       = module.tgw.this_ram_principal_association_id
}
