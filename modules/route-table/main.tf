################################################################################
# Route Table
################################################################################

resource "aws_ec2_transit_gateway_route_table" "this" {
  count = var.create ? 1 : 0

  transit_gateway_id = var.transit_gateway_id

  tags = merge(
    var.tags,
    { Name = var.name }
  )
}

resource "aws_ec2_transit_gateway_route_table_association" "this" {
  for_each = { for k,v in var.associations: k => v if var.create }

  transit_gateway_attachment_id  = each.value.transit_gateway_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this[0].id
  replace_existing_association = try(each.value.replace_existing_association, null)
}

resource "aws_ec2_transit_gateway_route_table_propagation" "this" {
  for_each = { for k,v in var.associations: k => v if var.create && try(v.propagate_route_table, false) }

  transit_gateway_attachment_id  = each.value.transit_gateway_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this[0].id
}

################################################################################
# Route(s)
################################################################################

resource "aws_ec2_transit_gateway_route" "this" {
  for_each = { for k,v in var.routes : k => v if var.create }

  destination_cidr_block = each.value.destination_cidr_block
  blackhole              = each.value.route_value.blackhole

  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this[0].id
  transit_gateway_attachment_id  = each.value.transit_gateway_attachment_id
}

resource "aws_route" "this" {
  for_each = { for k,v in var.vpc_routes : k => v if var.create }

  route_table_id              = each.value.route_table_id
  destination_cidr_block      = each.value.destination_cidr_block
  destination_ipv6_cidr_block = each.value.destination_ipv6_cidr_block
  transit_gateway_id          = aws_ec2_transit_gateway.this[0].id
}
