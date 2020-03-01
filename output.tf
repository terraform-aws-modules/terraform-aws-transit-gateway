// aws_ec2_transit_gateway
output "this_ec2_transit_gateway_arn" {
  description = "EC2 Transit Gateway Amazon Resource Name (ARN)"
  value       = element(concat(aws_ec2_transit_gateway.this.*.arn, [""]), 0)
}

output "this_ec2_transit_gateway_association_default_route_table_id" {
  description = "Identifier of the default association route table"
  value       = element(concat(aws_ec2_transit_gateway.this.*.association_default_route_table_id, [""]), 0)
}

output "this_ec2_transit_gateway_id" {
  description = "EC2 Transit Gateway identifier"
  value       = element(concat(aws_ec2_transit_gateway.this.*.id, [""]), 0)
}

output "this_ec2_transit_gateway_owner_id" {
  description = "Identifier of the AWS account that owns the EC2 Transit Gateway"
  value       = element(concat(aws_ec2_transit_gateway.this.*.owner_id, [""]), 0)
}

output "this_ec2_transit_gateway_propagation_default_route_table_id" {
  description = "Identifier of the default propagation route table"
  value       = element(concat(aws_ec2_transit_gateway.this.*.propagation_default_route_table_id, [""]), 0)
}

// aws_ec2_transit_gateway_route_table
output "this_ec2_transit_gateway_route_table_default_association_route_table" {
  description = "Boolean whether this is the default association route table for the EC2 Transit Gateway"
  value       = element(concat(aws_ec2_transit_gateway_route_table.this.*.default_association_route_table, [""]), 0)
}

output "this_ec2_transit_gateway_route_table_default_propagation_route_table" {
  description = "Boolean whether this is the default propagation route table for the EC2 Transit Gateway"
  value       = element(concat(aws_ec2_transit_gateway_route_table.this.*.default_propagation_route_table, [""]), 0)
}

output "this_ec2_transit_gateway_route_table_id" {
  description = "EC2 Transit Gateway Route Table identifier"
  value       = element(concat(aws_ec2_transit_gateway_route_table.this.*.id, [""]), 0)
}

// aws_ec2_transit_gateway_route
output "this_ec2_transit_gateway_route_ids" {
  description = "List of EC2 Transit Gateway Route Table identifier combined with destination"
  value       = var.transit_route_tables_map == {} ? aws_ec2_transit_gateway_route.this.*.id : values(aws_ec2_transit_gateway_route.from_var_transit_route_tables_map)[*].id
}

// aws_ec2_transit_gateway_vpc_attachment
output "this_ec2_transit_gateway_vpc_attachment_ids" {
  description = "List of EC2 Transit Gateway VPC Attachment identifiers"
  value       = [for k, v in aws_ec2_transit_gateway_vpc_attachment.this : v.id]
}

// aws_ec2_transit_gateway_vpn_attachment
output "this_ec2_transit_gateway_vpn_attachment_ids" {
  description = "List of EC2 Transit Gateway VPN Attachment identifiers"
  value       = [for k, v in data.aws_ec2_transit_gateway_vpn_attachment.this : v.id]
}

output "this_ec2_transit_gateway_vpc_attachment" {
  description = "Map of EC2 Transit Gateway VPC Attachment attributes"
  value       = aws_ec2_transit_gateway_vpc_attachment.this
}

// aws_ec2_transit_gateway_route_table_association
output "this_ec2_transit_gateway_route_table_association_ids" {
  description = "List of EC2 Transit Gateway Route Table Association identifiers using vpc_attachments with routes"
  value       = [for k, v in aws_ec2_transit_gateway_route_table_association.this : v.id]
}

output "this_ec2_transit_gateway_route_table_association" {
  description = "Map of EC2 Transit Gateway Route Table Association attributes using vpc_attachments with routes"
  value       = aws_ec2_transit_gateway_route_table_association.this
}

// aws_ec2_transit_gateway_route_table_propagation
output "this_ec2_transit_gateway_route_table_propagation_ids" {
  description = "List of EC2 Transit Gateway Route Table Propagation identifiers using vpc_attachments with routes"
  value       = [for k, v in aws_ec2_transit_gateway_route_table_propagation.this : v.id]
}

output "this_ec2_transit_gateway_route_table_propagation" {
  description = "Map of EC2 Transit Gateway Route Table Propagation attributes using vpc_attachments with routes"
  value       = aws_ec2_transit_gateway_route_table_propagation.this
}

// aws_ec2_transit_gateway_route_table_association
output "transit_route_tables_map_ec2_transit_gateway_route_table_association_ids" {
  description = "List of EC2 Transit Gateway Route Table Association identifiers using variable transit_route_tables_map"
  value       = { for k, v in aws_ec2_transit_gateway_route_table_association.from_var_transit_route_tables_map : k => v.id }
}

output "transit_route_tables_map_ec2_transit_gateway_route_table_association" {
  description = "Map of EC2 Transit Gateway Route Table Association attributes using variable transit_route_tables_map"
  value       = aws_ec2_transit_gateway_route_table_association.from_var_transit_route_tables_map
}

// aws_ec2_transit_gateway_route_table_propagation
output "transit_route_tables_map_ec2_transit_gateway_route_table_propagation_ids" {
  description = "List of EC2 Transit Gateway Route Table Propagation identifiers using variable transit_route_tables_map"
  value       = { for k, v in aws_ec2_transit_gateway_route_table_propagation.from_var_transit_route_tables_map : k => v.id }
}

output "transit_route_tables_map_ec2_transit_gateway_route_table_propagation" {
  description = "Map of EC2 Transit Gateway Route Table Propagation attributes using variable transit_route_tables_map"
  value       = aws_ec2_transit_gateway_route_table_propagation.from_var_transit_route_tables_map
}

// aws_ram_resource_share
output "this_ram_resource_share_id" {
  description = "The Amazon Resource Name (ARN) of the resource share"
  value       = element(concat(aws_ram_resource_share.this.*.id, [""]), 0)
}

// aws_ram_principal_association
output "this_ram_principal_association_id" {
  description = "The Amazon Resource Name (ARN) of the Resource Share and the principal, separated by a comma"
  value       = element(concat(aws_ram_principal_association.this.*.id, [""]), 0)
}
