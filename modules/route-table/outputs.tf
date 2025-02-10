################################################################################
# Transit Gateway
################################################################################

output "ec2_transit_gateway_propagation_default_route_table_id" {
  description = "Identifier of the default propagation route table"
  value       = try(aws_ec2_transit_gateway.this[0].propagation_default_route_table_id, "")
}

################################################################################
# VPC Attachment
################################################################################

output "ec2_transit_gateway_vpc_attachment_ids" {
  description = "List of EC2 Transit Gateway VPC Attachment identifiers"
  value       = [for k, v in aws_ec2_transit_gateway_vpc_attachment.this : v.id]
}

output "ec2_transit_gateway_vpc_attachment" {
  description = "Map of EC2 Transit Gateway VPC Attachment attributes"
  value       = aws_ec2_transit_gateway_vpc_attachment.this
}

################################################################################
# Route Table / Routes
################################################################################

output "ec2_transit_gateway_route_table_id" {
  description = "EC2 Transit Gateway Route Table identifier"
  value       = try(aws_ec2_transit_gateway_route_table.this[0].id, "")
}

output "ec2_transit_gateway_route_table_default_association_route_table" {
  description = "Boolean whether this is the default association route table for the EC2 Transit Gateway"
  value       = try(aws_ec2_transit_gateway_route_table.this[0].default_association_route_table, "")
}

output "ec2_transit_gateway_route_table_default_propagation_route_table" {
  description = "Boolean whether this is the default propagation route table for the EC2 Transit Gateway"
  value       = try(aws_ec2_transit_gateway_route_table.this[0].default_propagation_route_table, "")
}

output "ec2_transit_gateway_route_ids" {
  description = "List of EC2 Transit Gateway Route Table identifier combined with destination"
  value       = aws_ec2_transit_gateway_route.this[*].id
}

output "ec2_transit_gateway_route_table_association_ids" {
  description = "List of EC2 Transit Gateway Route Table Association identifiers"
  value       = [for k, v in aws_ec2_transit_gateway_route_table_association.this : v.id]
}

output "ec2_transit_gateway_route_table_association" {
  description = "Map of EC2 Transit Gateway Route Table Association attributes"
  value       = aws_ec2_transit_gateway_route_table_association.this
}

output "ec2_transit_gateway_route_table_propagation_ids" {
  description = "List of EC2 Transit Gateway Route Table Propagation identifiers"
  value       = [for k, v in aws_ec2_transit_gateway_route_table_propagation.this : v.id]
}

output "ec2_transit_gateway_route_table_propagation" {
  description = "Map of EC2 Transit Gateway Route Table Propagation attributes"
  value       = aws_ec2_transit_gateway_route_table_propagation.this
}
