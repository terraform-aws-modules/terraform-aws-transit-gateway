# Variables for the module
variable "tgw_id" {
  description = "The ID of the transit gateway"
  type        = string
}

variable "cidr_blocks" {
  description = "A list of CIDR blocks to route"
  type        = list(string)
}

variable "tgw_peering_tag_name_value" {
  description = "The value of the Name tag for the Transit Gateway Peering Attachment"
  type        = string
}
