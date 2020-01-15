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

//output "this_ec2_transit_gateway_route_ids" {
//  description = "List of EC2 Transit Gateway Route Table identifier combined with destination"
//  value       = element(concat(aws_ec2_transit_gateway_route.this.*.id, [""]), 0)
//}
