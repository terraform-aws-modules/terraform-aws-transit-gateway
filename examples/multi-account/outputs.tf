################################################################################
# Transit Gateway
################################################################################

output "arn" {
  description = "EC2 Transit Gateway Amazon Resource Name (ARN)"
  value       = module.transit_gateway.arn
}

output "id" {
  description = "EC2 Transit Gateway identifier"
  value       = module.transit_gateway.id
}

output "owner_id" {
  description = "Identifier of the AWS account that owns the EC2 Transit Gateway"
  value       = module.transit_gateway.owner_id
}

output "association_default_route_table_id" {
  description = "Identifier of the default association route table"
  value       = module.transit_gateway.association_default_route_table_id
}

output "propagation_default_route_table_id" {
  description = "Identifier of the default propagation route table"
  value       = module.transit_gateway.propagation_default_route_table_id
}

################################################################################
# Resource Access Manager
################################################################################

output "ram_resource_share_id" {
  description = "The Amazon Resource Name (ARN) of the resource share"
  value       = module.transit_gateway.ram_resource_share_id
}

################################################################################
# VPC Attachment
################################################################################

output "vpc_attachments" {
  description = "Map of VPC attachments created"
  value       = module.transit_gateway.vpc_attachments
}

################################################################################
# TGW Peering Attachment
################################################################################

output "peering_attachments" {
  description = "Map of TGW peering attachments created"
  value       = module.transit_gateway.peering_attachments
}
