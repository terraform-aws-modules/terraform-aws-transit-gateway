variable "create" {
  description = "Controls if resources should be created (it affects almost all resources)"
  type        = bool
  default     = true
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
# Route Table
################################################################################

variable "transit_gateway_id" {
  description = "The ID of the EC2 Transit Gateway"
  type        = string
  default     = ""
}

variable "associations" {
  description = "A map of transit gateway attachment IDs to associate with the Transit Gateway route table"
  type = map(object({
    transit_gateway_attachment_id = optional(string)
    replace_existing_association  = optional(bool)
    propagate_route_table         = optional(bool, false)
  }))
  default = {}
}

################################################################################
# Route(s)
################################################################################

variable "routes" {
  description = "A map of Transit Gateway routes to create in the route table"
  type = map(object({
    destination_cidr_block        = string
    blackhole                     = optional(bool, false)
    transit_gateway_attachment_id = optional(string)
  }))
  default = {}
}

variable "vpc_routes" {
  description = "A map of VPC routes to create in the route table provided"
  type = map(object({
    route_table_id              = string
    destination_cidr_block      = optional(string)
    destination_ipv6_cidr_block = optional(string)
  }))
  default = {}
}
