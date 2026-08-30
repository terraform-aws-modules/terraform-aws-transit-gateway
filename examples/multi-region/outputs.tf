output "peering_attachment" {
  description = "The peering attachment created in the first Region"
  value       = module.tgw_a.ec2_transit_gateway_peering_attachment
}

output "peering_attachment_accepter" {
  description = "The peering attachment as accepted in the second Region"
  value       = module.tgw_b_peering_accepter.ec2_transit_gateway_peering_attachment_accepter
}
