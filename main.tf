resource "aws_ec2_transit_gateway" "this" {
  count = var.create_tgw ? 1 : 0

  description                     = coalesce(var.description, var.name)
  amazon_side_asn                 = var.amazon_side_asn
  default_route_table_association = var.enable_default_route_table_association ? "enable" : "disable"
  default_route_table_propagation = var.enable_default_route_table_propagation ? "enable" : "disable"
  auto_accept_shared_attachments  = var.enable_auto_accept_shared_attachments ? "enable" : "disable"
  vpn_ecmp_support                = var.enable_vpn_ecmp_support ? "enable" : "disable"
  dns_support                     = var.enable_dns_support ? "enable" : "disable"

  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags,
    var.tgw_tags,
  )
}

resource "aws_ec2_transit_gateway_route_table" "this" {
  count = var.create_tgw && var.create_tgw_route_table ? 1 : 0

  transit_gateway_id = aws_ec2_transit_gateway.this[0].id

  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags,
    var.tgw_route_table_tags,
  )
}

//
//resource "aws_ec2_transit_gateway_route" "this" {
//  for_each = var.tgw_routes
//
//  transit_gateway_route_table_id = each.value["transit_gateway_route_table_id"]
//  destination_cidr_block    = each.value["destination_cidr_block"]
//  transit_gateway_attachment_id = each.value["transit_gateway_attachment_id"]
//  blackhole       = each.value["blackhole"]
//
//  /*
//  destination_cidr_block - (Required) IPv4 CIDR range used for destination matches. Routing decisions are based on the most specific match.
//transit_gateway_attachment_id - (Optional) Identifier of EC2 Transit Gateway Attachment (required if blackhole is set to false).
//blackhole - (Optional) Indicates whether to drop traffic that matches this route (default to false).
//transit_gateway_route_table_id - (Required) Identifier of EC2 Transit Gateway Route Table.
//  */
//
//  tags = merge(
//  {
//    Name = format("%s-%s", var.name, each.key)
//  },
//  var.tags,
//  var.tgw_route_tags,
//  )
//}

# #########
# # Transit Gateway Attachment
# #########
//resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
//  count = "${(var.create_tgw || var.attach_tgw) && (var.subnet_type_tgw_attachment == "private" || var.subnet_type_tgw_attachment == "public") ? 1 : 0}"
//
//  subnet_ids                                      = ["${split(",", var.subnet_type_tgw_attachment == "private" ? join(",", aws_subnet.private.*.id ) : join(",", aws_subnet.public.*.id))}"]
//  transit_gateway_id                              = "${element(concat(aws_ec2_transit_gateway.this.*.id, list(var.attach_tgw_id)), 0)}"
//  vpc_id                                          = "${aws_vpc.this.id}"
//  transit_gateway_default_route_table_association = "${var.tgw_attach_default_route_table_association}"
//  transit_gateway_default_route_table_propagation = "${var.tgw_attach_default_route_table_propagation}"
//
//  tags = "${merge(map("Name", format("%s", var.name)), var.tags, var.tgw_tags)}"
//}
//
//resource "aws_ec2_transit_gateway_route_table" "this" {
//  count = "${(var.attach_tgw  && var.attach_tgw_route_vpc ? false:true) && (var.create_tgw || var.attach_tgw) && (var.subnet_type_tgw_attachment == "private" || var.subnet_type_tgw_attachment == "public")? 1 : 0}"
//
//  # count = "${false && (var.create_tgw || var.attach_tgw) && (var.subnet_type_tgw_attachment == "private" || var.subnet_type_tgw_attachment == "public")? 1 : 0}"
//
//  transit_gateway_id = "${element(concat(aws_ec2_transit_gateway.this.*.id, list(var.attach_tgw_id)), 0)}"
//  tags = "${merge(map("Name", format("%s", var.name)), var.tags, var.tgw_tags)}"
//}

#########
# Transit Gateway Route table association and propagation for TGW Attachements
#########
//resource "aws_ec2_transit_gateway_route_table_association" "this" {
//  count = "${(var.attach_tgw  && var.attach_tgw_route_vpc ? false:true) && (var.create_tgw || var.attach_tgw )&& (var.subnet_type_tgw_attachment == "private" || var.subnet_type_tgw_attachment == "public") ? 1 : 0}"
//
//  transit_gateway_attachment_id  = "${element(aws_ec2_transit_gateway_vpc_attachment.this.*.id, 0)}"
//  transit_gateway_route_table_id = "${element(aws_ec2_transit_gateway_route_table.this.*.id, 0)}"
//}
//
//resource "aws_ec2_transit_gateway_route_table_propagation" "this" {
//  count = "${(var.attach_tgw  && var.attach_tgw_route_vpc ? false:true) && (var.create_tgw || var.attach_tgw) && (var.subnet_type_tgw_attachment == "private" || var.subnet_type_tgw_attachment == "public") ? 1 : 0}"
//
//  transit_gateway_attachment_id  = "${element(aws_ec2_transit_gateway_vpc_attachment.this.*.id, 0)}"
//  transit_gateway_route_table_id = "${element(aws_ec2_transit_gateway_route_table.this.*.id, 0)}"
//}
//
//resource "aws_ec2_transit_gateway_route_table_association" "existing_rt" {
//  count = "${((var.attach_tgw  && var.attach_tgw_route_vpc) && (var.subnet_type_tgw_attachment == "private" || var.subnet_type_tgw_attachment == "public") ? 1:0)}"
//
//  transit_gateway_attachment_id  = "${element(aws_ec2_transit_gateway_vpc_attachment.this.*.id, 0)}"
//  transit_gateway_route_table_id = "${var.tgw_rt_id}"
//}
//
//resource "aws_ec2_transit_gateway_route_table_propagation" "existing_rt" {
//  count = "${((var.attach_tgw  && var.attach_tgw_route_vpc) && (var.subnet_type_tgw_attachment == "private" || var.subnet_type_tgw_attachment == "public") ? 1:0)}"
//
//  transit_gateway_attachment_id  = "${element(aws_ec2_transit_gateway_vpc_attachment.this.*.id, 0)}"
//  transit_gateway_route_table_id = "${var.tgw_rt_id}"
//}

########
# Routes to TGW are added to the Subnets.
########
//locals {
//  route_table_id = ["${split(",", var.subnet_type_tgw_attachment == "private" ? join(",", aws_route_table.private.*.id ) : join(",", aws_route_table.public.*.id))}"]
//}
//
//resource "aws_route" "tgw_route" {
//  count = "${(var.create_tgw || var.attach_tgw) && length(var.cidr_tgw) > 0 && (var.subnet_type_tgw_attachment == "private" || var.subnet_type_tgw_attachment == "public") ? length(var.cidr_tgw) : 0}"
//
//  route_table_id         = "${element(local.route_table_id, ceil(count.index/length(var.cidr_tgw)))}"
//  destination_cidr_block = "${element(var.cidr_tgw, count.index)}"
//  transit_gateway_id     = "${element(concat(aws_ec2_transit_gateway.this.*.id, list(var.attach_tgw_id)), 0)}"
//
//
//  depends_on = ["aws_route_table.public","aws_route_table.private"]
//
//  timeouts {
//    create = "5m"
//  }
//}





// RAM resources - https://aws.amazon.com/ram/
//resource "aws_ram_resource_share" "this" {
//  count = var.create_tgw && var.share_tgw ? 1 : 0
//
//  name                      = var.name
//  allow_external_principals = var.allow_external_principals
//
//
//  tags = merge(
//  {
//    "Name" = format("%s", var.name)
//  },
//  var.tags,
//  var.ram_resource_share_tags,
//  )
//}
//
//resource "aws_ram_resource_association" "ram_resource_association" {
//  count = "${var.create_tgw && var.share_tgw ? 1 : 0}"
//
//  resource_arn       = "${aws_ec2_transit_gateway.tgw.arn}"
//  resource_share_arn = "${aws_ram_resource_share.ram_share.id}"
//}
//
//resource "aws_ram_principal_association" "ram_principal_association" {
//  count = "${var.create_tgw && var.share_tgw && length(var.ram_share_principals) > 0 ? length(var.ram_share_principals) : 0}"
//
//  principal          = "${var.ram_share_principals[count.index]}"
//  resource_share_arn = "${aws_ram_resource_share.ram_share.arn}"
//}
