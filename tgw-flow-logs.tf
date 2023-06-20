resource "aws_flow_log" "this" {
  for_each = { for k, v in var.flow_logs : "${v.key}-${v.dest_type}" => v if v.dest_enabled }

  log_destination_type = each.value.dest_type
  log_destination = {
    s3               = each.value.s3_dest_arn,
    cloud-watch-logs = each.value.cloudwatch_dest_arn
  }[each.value.dest_type]
  log_format         = try(each.value.log_format, null)
  iam_role_arn       = each.value.dest_type == "cloud-watch-logs" ? each.value.cloudwatch_iam_role_arn : null
  traffic_type       = try(each.value.traffic_type, "ALL")
  transit_gateway_id = each.value.key == "tgw" && var.create_tgw ? aws_ec2_transit_gateway.this[0].id : null
  transit_gateway_attachment_id = each.value.key != "tgw" ? lookup({
    vpc     = each.value.create_vpc_attachment ? aws_ec2_transit_gateway_vpc_attachment.this[each.value.key].id : null
    peering = each.value.create_tgw_peering ? aws_ec2_transit_gateway_peering_attachment.this[each.value.key].id : null
  }, each.value.attachment_type, null) : null
  # When transit_gateway_id or transit_gateway_attachment_id is specified, max_aggregation_interval must be 60 seconds (1 minute).
  max_aggregation_interval = 60

  dynamic "destination_options" {
    for_each = each.value.dest_type == "s3" ? [true] : []

    content {
      file_format                = try(each.value.file_format, "parquet")
      hive_compatible_partitions = try(each.value.hive_compatible_partitions, false)
      per_hour_partition         = try(each.value.per_hour_partition, true)
    }
  }

  tags = merge(var.tags, var.tgw_flow_log_tags)

  depends_on = [
    aws_ec2_transit_gateway.this,
    aws_ec2_transit_gateway_peering_attachment.this,
    data.aws_ec2_transit_gateway_vpc_attachment.this,
  ]
}
