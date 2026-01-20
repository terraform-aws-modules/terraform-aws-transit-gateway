variable "create" {
  description = "Controls if resources should be created (it affects almost all resources)"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name to be used on all the resources as the identifier"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "region" {
  description = "Region where the resource(s) will be managed. Defaults to the region set in the provider configuration"
  type        = string
  default     = null
}

################################################################################
# Transit Gateway
################################################################################

variable "amazon_side_asn" {
  description = "The Autonomous System Number (ASN) for the Amazon side of the gateway. By default the TGW is created with the current default Amazon ASN"
  type        = string
  default     = null
}

variable "auto_accept_shared_attachments" {
  description = "Whether resource attachment requests are automatically accepted"
  type        = bool
  default     = true
}

variable "default_route_table_association" {
  description = "Whether resource attachments are automatically associated with the default association route table"
  type        = bool
  default     = false
}

variable "default_route_table_propagation" {
  description = "Whether resource attachments automatically propagate routes to the default propagation route table"
  type        = bool
  default     = false
}

variable "description" {
  description = "Description of the EC2 Transit Gateway"
  type        = string
  default     = null
}

variable "dns_support" {
  description = "Should be true to enable DNS support in the TGW"
  type        = bool
  default     = true
}

variable "multicast_support" {
  description = "Whether multicast support is enabled"
  type        = bool
  default     = false
}

variable "security_group_referencing_support" {
  description = "Whether security group referencing is enabled"
  type        = bool
  default     = false
}

variable "transit_gateway_cidr_blocks" {
  description = "One or more IPv4 or IPv6 CIDR blocks for the transit gateway. Must be a size /24 CIDR block or larger for IPv4, or a size /64 CIDR block or larger for IPv6"
  type        = list(string)
  default     = []
}

variable "vpn_ecmp_support" {
  description = "Whether VPN Equal Cost Multipath Protocol support is enabled"
  type        = bool
  default     = true
}

variable "timeouts" {
  description = "Create, update, and delete timeout configurations for the transit gateway"
  type = object({
    create = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  default = null
}

variable "tgw_tags" {
  description = "Additional tags for the TGW"
  type        = map(string)
  default     = {}
}

################################################################################
# VPC Attachment
################################################################################

variable "vpc_attachments" {
  description = "Map of VPC route table attachments to create"
  type = map(object({
    appliance_mode_support                          = optional(bool, false)
    dns_support                                     = optional(bool, true)
    ipv6_support                                    = optional(bool, false)
    security_group_referencing_support              = optional(bool, false)
    subnet_ids                                      = list(string)
    tags                                            = optional(map(string), {})
    transit_gateway_default_route_table_association = optional(bool, false)
    transit_gateway_default_route_table_propagation = optional(bool, false)
    vpc_id                                          = string

    accept_peering_attachment = optional(bool, false)
  }))
  default = {}
}

variable "peering_attachments" {
  description = "Map of Transit Gateway peering attachments to create"
  type = map(object({
    peer_account_id         = string
    peer_region             = string
    peer_transit_gateway_id = string
    tags                    = optional(map(string), {})

    accept_peering_attachment = optional(bool, false)
  }))
  default = {}
}

################################################################################
# Resource Access Manager
################################################################################

variable "enable_ram_share" {
  description = "Whether to share your transit gateway with other accounts"
  type        = bool
  default     = false
}

variable "ram_name" {
  description = "The name of the resource share of TGW"
  type        = string
  default     = ""
}

variable "ram_allow_external_principals" {
  description = "Indicates whether principals outside your organization can be associated with a resource share"
  type        = bool
  default     = false
}

variable "ram_principals" {
  description = "A list of principals to share TGW with. Possible values are an AWS account ID, an AWS Organizations Organization ARN, or an AWS Organizations Organization Unit ARN"
  type        = set(string)
  default     = []
}

variable "ram_tags" {
  description = "Additional tags for the RAM"
  type        = map(string)
  default     = {}
}
