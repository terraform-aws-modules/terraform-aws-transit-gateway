################################################################################
# Primary Hub Transit Gateway
################################################################################

output "primary_hub_ec2_transit_gateway_arn" {
  description = "EC2 Transit Gateway Amazon Resource Name (ARN)"
  value       = module.primary_hub.ec2_transit_gateway_arn
}

output "primary_hub_ec2_transit_gateway_id" {
  description = "EC2 Transit Gateway identifier"
  value       = module.primary_hub.ec2_transit_gateway_id
}

output "primary_hub_ec2_transit_gateway_owner_id" {
  description = "Identifier of the AWS account that owns the EC2 Transit Gateway"
  value       = module.primary_hub.ec2_transit_gateway_owner_id
}

output "primary_hub_ec2_transit_gateway_association_default_route_table_id" {
  description = "Identifier of the default association route table"
  value       = module.primary_hub.ec2_transit_gateway_association_default_route_table_id
}

output "primary_hub_ec2_transit_gateway_propagation_default_route_table_id" {
  description = "Identifier of the default propagation route table"
  value       = module.primary_hub.ec2_transit_gateway_propagation_default_route_table_id
}

################################################################################
# Primary Hub VPC Attachment
################################################################################

output "primary_hub_ec2_transit_gateway_vpc_attachment_ids" {
  description = "List of EC2 Transit Gateway VPC Attachment identifiers"
  value       = module.primary_hub.ec2_transit_gateway_vpc_attachment_ids
}

output "primary_hub_ec2_transit_gateway_vpc_attachment" {
  description = "Map of EC2 Transit Gateway VPC Attachment attributes"
  value       = module.primary_hub.ec2_transit_gateway_vpc_attachment
}

################################################################################
# Primary Hub Route Table / Routes
################################################################################

output "primary_hub_ec2_transit_gateway_route_table_id" {
  description = "EC2 Transit Gateway Route Table identifier"
  value       = module.primary_hub.ec2_transit_gateway_route_table_id
}

output "primary_hub_ec2_transit_gateway_route_table_default_association_route_table" {
  description = "Boolean whether this is the default association route table for the EC2 Transit Gateway"
  value       = module.primary_hub.ec2_transit_gateway_route_table_default_association_route_table
}

output "primary_hub_ec2_transit_gateway_route_table_default_propagation_route_table" {
  description = "Boolean whether this is the default propagation route table for the EC2 Transit Gateway"
  value       = module.primary_hub.ec2_transit_gateway_route_table_default_propagation_route_table
}

output "primary_hub_ec2_transit_gateway_route_ids" {
  description = "List of EC2 Transit Gateway Route Table identifier combined with destination"
  value       = module.primary_hub.ec2_transit_gateway_route_ids
}

output "primary_hub_ec2_transit_gateway_route_table_association_ids" {
  description = "List of EC2 Transit Gateway Route Table Association identifiers"
  value       = module.primary_hub.ec2_transit_gateway_route_table_association_ids
}

output "primary_hub_ec2_transit_gateway_route_table_association" {
  description = "Map of EC2 Transit Gateway Route Table Association attributes"
  value       = module.primary_hub.ec2_transit_gateway_route_table_association
}

output "primary_hub_ec2_transit_gateway_route_table_propagation_ids" {
  description = "List of EC2 Transit Gateway Route Table Propagation identifiers"
  value       = module.primary_hub.ec2_transit_gateway_route_table_propagation_ids
}

output "primary_hub_ec2_transit_gateway_route_table_propagation" {
  description = "Map of EC2 Transit Gateway Route Table Propagation attributes"
  value       = module.primary_hub.ec2_transit_gateway_route_table_propagation
}

################################################################################
# Primary Hub Resource Access Manager
################################################################################

output "primary_hub_ram_resource_share_id" {
  description = "The Amazon Resource Name (ARN) of the resource share"
  value       = module.primary_hub.ram_resource_share_id
}

output "primary_hub_ram_principal_association_id" {
  description = "The Amazon Resource Name (ARN) of the Resource Share and the principal, separated by a comma"
  value       = module.primary_hub.ram_principal_association_id
}

################################################################################
# Primary Spoke VPC Attachment
################################################################################

output "primary_spoke_ec2_transit_gateway_vpc_attachment_ids" {
  description = "List of EC2 Transit Gateway VPC Attachment identifiers"
  value       = module.primary_spoke.ec2_transit_gateway_vpc_attachment_ids
}

output "primary_spoke_ec2_transit_gateway_vpc_attachment" {
  description = "Map of EC2 Transit Gateway VPC Attachment attributes"
  value       = module.primary_spoke.ec2_transit_gateway_vpc_attachment
}

################################################################################
# Peer Hub Transit Gateway
################################################################################

output "peer_hub_ec2_transit_gateway_arn" {
  description = "EC2 Transit Gateway Amazon Resource Name (ARN)"
  value       = module.peer_hub.ec2_transit_gateway_arn
}

output "peer_hub_ec2_transit_gateway_id" {
  description = "EC2 Transit Gateway identifier"
  value       = module.peer_hub.ec2_transit_gateway_id
}

output "peer_hub_ec2_transit_gateway_owner_id" {
  description = "Identifier of the AWS account that owns the EC2 Transit Gateway"
  value       = module.peer_hub.ec2_transit_gateway_owner_id
}

output "peer_hub_ec2_transit_gateway_association_default_route_table_id" {
  description = "Identifier of the default association route table"
  value       = module.peer_hub.ec2_transit_gateway_association_default_route_table_id
}

output "peer_hub_ec2_transit_gateway_propagation_default_route_table_id" {
  description = "Identifier of the default propagation route table"
  value       = module.peer_hub.ec2_transit_gateway_propagation_default_route_table_id
}

################################################################################
# Peer Hub VPC Attachment
################################################################################

output "peer_hub_ec2_transit_gateway_vpc_attachment_ids" {
  description = "List of EC2 Transit Gateway VPC Attachment identifiers"
  value       = module.peer_hub.ec2_transit_gateway_vpc_attachment_ids
}

output "peer_hub_ec2_transit_gateway_vpc_attachment" {
  description = "Map of EC2 Transit Gateway VPC Attachment attributes"
  value       = module.peer_hub.ec2_transit_gateway_vpc_attachment
}

################################################################################
# Peer Hub Route Table / Routes
################################################################################

output "peer_hub_ec2_transit_gateway_route_table_id" {
  description = "EC2 Transit Gateway Route Table identifier"
  value       = module.peer_hub.ec2_transit_gateway_route_table_id
}

output "peer_hub_ec2_transit_gateway_route_table_default_association_route_table" {
  description = "Boolean whether this is the default association route table for the EC2 Transit Gateway"
  value       = module.peer_hub.ec2_transit_gateway_route_table_default_association_route_table
}

output "peer_hub_ec2_transit_gateway_route_table_default_propagation_route_table" {
  description = "Boolean whether this is the default propagation route table for the EC2 Transit Gateway"
  value       = module.peer_hub.ec2_transit_gateway_route_table_default_propagation_route_table
}

output "peer_hub_ec2_transit_gateway_route_ids" {
  description = "List of EC2 Transit Gateway Route Table identifier combined with destination"
  value       = module.peer_hub.ec2_transit_gateway_route_ids
}

output "peer_hub_ec2_transit_gateway_route_table_association_ids" {
  description = "List of EC2 Transit Gateway Route Table Association identifiers"
  value       = module.peer_hub.ec2_transit_gateway_route_table_association_ids
}

output "peer_hub_ec2_transit_gateway_route_table_association" {
  description = "Map of EC2 Transit Gateway Route Table Association attributes"
  value       = module.peer_hub.ec2_transit_gateway_route_table_association
}

output "peer_hub_ec2_transit_gateway_route_table_propagation_ids" {
  description = "List of EC2 Transit Gateway Route Table Propagation identifiers"
  value       = module.peer_hub.ec2_transit_gateway_route_table_propagation_ids
}

output "peer_hub_ec2_transit_gateway_route_table_propagation" {
  description = "Map of EC2 Transit Gateway Route Table Propagation attributes"
  value       = module.peer_hub.ec2_transit_gateway_route_table_propagation
}

################################################################################
# Peer Hub Resource Access Manager
################################################################################

output "peer_hub_ram_resource_share_id" {
  description = "The Amazon Resource Name (ARN) of the resource share"
  value       = module.peer_hub.ram_resource_share_id
}

output "peer_hub_ram_principal_association_id" {
  description = "The Amazon Resource Name (ARN) of the Resource Share and the principal, separated by a comma"
  value       = module.peer_hub.ram_principal_association_id
}

################################################################################
# Peer Spoke VPC Attachment
################################################################################

output "peer_spoke_ec2_transit_gateway_vpc_attachment_ids" {
  description = "List of EC2 Transit Gateway VPC Attachment identifiers"
  value       = module.peer_spoke.ec2_transit_gateway_vpc_attachment_ids
}

output "peer_spoke_ec2_transit_gateway_vpc_attachment" {
  description = "Map of EC2 Transit Gateway VPC Attachment attributes"
  value       = module.peer_spoke.ec2_transit_gateway_vpc_attachment
}
