################################################################################
# Transit Gateway
################################################################################

output "arn" {
  description = "EC2 Transit Gateway Amazon Resource Name (ARN)"
  value       = module.tgw.arn
}

output "id" {
  description = "EC2 Transit Gateway identifier"
  value       = module.tgw.id
}

output "owner_id" {
  description = "Identifier of the AWS account that owns the EC2 Transit Gateway"
  value       = module.tgw.owner_id
}

output "association_default_route_table_id" {
  description = "Identifier of the default association route table"
  value       = module.tgw.association_default_route_table_id
}

output "propagation_default_route_table_id" {
  description = "Identifier of the default propagation route table"
  value       = module.tgw.propagation_default_route_table_id
}

################################################################################
# Resource Access Manager
################################################################################

output "ram_resource_share_id" {
  description = "The Amazon Resource Name (ARN) of the resource share"
  value       = module.tgw.ram_resource_share_id
}
