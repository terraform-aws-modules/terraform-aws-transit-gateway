# Get the attachment ID for the transit gateway
data "aws_ec2_transit_gateway_attachment" "attachment" {
  filter {
    name   = "transit-gateway-id"
    values = [var.tgw_id]
  }

  filter {
    name   = "resource-type"
    values = ["peering"]
  }

  # Tag
  filter {
    name   = "tag:Name"
    values = [var.tgw_peering_tag_name_value]
  }
}

# Get the route table ID for the transit gateway
data "aws_ec2_transit_gateway_route_table" "route_table" {
  filter {
    name   = "transit-gateway-id"
    values = [var.tgw_id]
  }

  filter {
    name   = "default-association-route-table"
    values = ["true"]
  }
}

# Add routes to the specified Transit Gateway Route Table
resource "aws_ec2_transit_gateway_route" "this" {
  for_each = toset(var.cidr_blocks)

  destination_cidr_block         = each.value
  transit_gateway_route_table_id = data.aws_ec2_transit_gateway_route_table.route_table.id
  transit_gateway_attachment_id  = data.aws_ec2_transit_gateway_attachment.attachment.id
}
