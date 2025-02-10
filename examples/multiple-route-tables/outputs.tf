################################################################################
# VPC Attachment
################################################################################

output "ec2_transit_gateway_vpc_attachment_ids" {
  description = "List of EC2 Transit Gateway VPC Attachment identifiers"
  value       = module.tgw.ec2_transit_gateway_vpc_attachment_ids
}

output "ec2_transit_gateway_vpc_attachment" {
  description = "Map of EC2 Transit Gateway VPC Attachment attributes"
  value       = module.tgw.ec2_transit_gateway_vpc_attachment
}

################################################################################
# Route Table / Routes
################################################################################

output "ec2_transit_gateway_route_table_id" {
  description = "EC2 Transit Gateway Route Table identifier"
  value       = module.tgw_rtb2.ec2_transit_gateway_route_table_id
}

output "ec2_transit_gateway_route_ids" {
  description = "List of EC2 Transit Gateway Route Table identifier combined with destination"
  value       = module.tgw_rtb2.ec2_transit_gateway_route_ids
}

output "ec2_transit_gateway_route_table_association_ids" {
  description = "List of EC2 Transit Gateway Route Table Association identifiers"
  value       = module.tgw_rtb2.ec2_transit_gateway_route_table_association_ids
}

output "ec2_transit_gateway_route_table_association" {
  description = "Map of EC2 Transit Gateway Route Table Association attributes"
  value       = module.tgw_rtb2.ec2_transit_gateway_route_table_association
}

output "ec2_transit_gateway_route_table_propagation_ids" {
  description = "List of EC2 Transit Gateway Route Table Propagation identifiers"
  value       = module.tgw_rtb2.ec2_transit_gateway_route_table_propagation_ids
}

output "ec2_transit_gateway_route_table_propagation" {
  description = "Map of EC2 Transit Gateway Route Table Propagation attributes"
  value       = module.tgw_rtb2.ec2_transit_gateway_route_table_propagation
}
