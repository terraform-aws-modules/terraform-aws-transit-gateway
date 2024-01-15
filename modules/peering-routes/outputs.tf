output "route_table_id" {
  description = "The ID of the route table"
  value       = data.aws_ec2_transit_gateway_route_table.route_table.id
}

output "route_ids" {
  description = "The IDs of the TGW routes"
  value       = [for r in aws_ec2_transit_gateway_route.this : r.id]
}

output "route_table_association_ids" {
  description = "The IDs of the TGW route table associations"
  value       = [for r in aws_ec2_transit_gateway_route.this : r.transit_gateway_attachment_id]
}
