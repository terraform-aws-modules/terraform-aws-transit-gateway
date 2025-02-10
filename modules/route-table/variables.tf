variable "transit_gateway_id" {
  description = "Identifier of EC2 Transit Gateway to use with the Target Gateway route table"
  type        = string
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

################################################################################
# Transit Gateway
################################################################################

variable "enable_default_route_table_association" {
  description = "Whether resource attachments are automatically associated with the default association route table"
  type        = bool
  default     = false
}

variable "enable_default_route_table_propagation" {
  description = "Whether resource attachments automatically propagate routes to the default propagation route table"
  type        = bool
  default     = false
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the TGW attachment"
  type        = bool
  default     = true
}

variable "enable_ipv6_support" {
  description = "Should be true to enable IPv6 support in the TGW attachment"
  type        = bool
  default     = false
}

variable "enable_sg_referencing_support" {
  description = "Indicates whether to enable security group referencing support"
  type        = bool
  default     = true
}

################################################################################
# VPC Attachment
################################################################################

variable "vpc_attachments" {
  description = "Maps of maps of VPC details to attach to TGW. Type 'any' to disable type validation by Terraform."
  type        = any
  default     = {}
}

variable "tgw_vpc_attachment_tags" {
  description = "Additional tags for VPC attachments"
  type        = map(string)
  default     = {}
}

################################################################################
# Route Table / Routes
################################################################################

variable "tgw_route_table_tags" {
  description = "Additional tags for the TGW route table"
  type        = map(string)
  default     = {}
}
