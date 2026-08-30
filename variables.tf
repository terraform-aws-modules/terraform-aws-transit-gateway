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

variable "region" {
  description = "Region where the resource(s) will be managed. Defaults to the region set in the provider configuration"
  type        = string
  default     = null
}

################################################################################
# Transit Gateway
################################################################################

variable "create" {
  description = "Controls if resources should be created (affects nearly all resources)"
  type        = bool
  default     = true
}

variable "create_tgw" {
  description = "Controls if TGW should be created (it affects almost all resources)"
  type        = bool
  default     = true
}

variable "description" {
  description = "Description of the EC2 Transit Gateway"
  type        = string
  default     = null
}

variable "amazon_side_asn" {
  description = "The Autonomous System Number (ASN) for the Amazon side of the gateway. By default the TGW is created with the current default Amazon ASN."
  type        = string
  default     = null
}

variable "enable_default_route_table_association" {
  description = "Whether resource attachments are automatically associated with the default association route table"
  type        = bool
  default     = true
}

variable "enable_default_route_table_propagation" {
  description = "Whether resource attachments automatically propagate routes to the default propagation route table"
  type        = bool
  default     = true
}

variable "enable_auto_accept_shared_attachments" {
  description = "Whether resource attachment requests are automatically accepted"
  type        = bool
  default     = false
}

variable "enable_vpn_ecmp_support" {
  description = "Whether VPN Equal Cost Multipath Protocol support is enabled"
  type        = bool
  default     = true
}

variable "enable_multicast_support" {
  description = "Whether multicast support is enabled"
  type        = bool
  default     = false
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the TGW"
  type        = bool
  default     = true
}

variable "enable_encryption_support" {
  description = "Should be true to enable encryption support in the TGW"
  type        = bool
  default     = false
}

variable "transit_gateway_cidr_blocks" {
  description = "One or more IPv4 or IPv6 CIDR blocks for the transit gateway. Must be a size /24 CIDR block or larger for IPv4, or a size /64 CIDR block or larger for IPv6"
  type        = list(string)
  default     = []
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

variable "tgw_default_route_table_tags" {
  description = "Additional tags for the Default TGW route table"
  type        = map(string)
  default     = {}
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

variable "create_tgw_routes" {
  description = "Controls if TGW Route Table / Routes should be created"
  type        = bool
  default     = true
}

variable "transit_gateway_route_table_id" {
  description = "Identifier of EC2 Transit Gateway Route Table to use with the Target Gateway when reusing it between multiple TGWs"
  type        = string
  default     = null
}

variable "tgw_route_table_tags" {
  description = "Additional tags for the TGW route table"
  type        = map(string)
  default     = {}
}

################################################################################
# Resource Access Manager
################################################################################

variable "share_tgw" {
  description = "Whether to share your transit gateway with other accounts"
  type        = bool
  default     = true
}

variable "ram_name" {
  description = "The name of the resource share of TGW"
  type        = string
  default     = ""
}

variable "ram_allow_external_principals" {
  description = "Indicates whether principals outside your organization can be associated with a resource share."
  type        = bool
  default     = false
}

variable "ram_principals" {
  description = "A list of principals to share TGW with. Possible values are an AWS account ID, an AWS Organizations Organization ARN, or an AWS Organizations Organization Unit ARN"
  type        = list(string)
  default     = []
}

variable "ram_resource_share_arn" {
  description = "ARN of RAM resource share"
  type        = string
  default     = ""
}

variable "ram_tags" {
  description = "Additional tags for the RAM"
  type        = map(string)
  default     = {}
}

################################################################################
# Peering Attachment
################################################################################

variable "peering_attachments" {
  description = "Map of peering attachments to create from this transit gateway to one in another Region or account. The other side must accept them"
  type = map(object({
    peer_transit_gateway_id = string
    peer_region             = string
    # Defaults to the account the provider is connected to
    peer_account_id = optional(string)
    # Used when `create_tgw` is `false` and the transit gateway is managed elsewhere
    transit_gateway_id = optional(string)
    options = optional(object({
      dynamic_routing = optional(string)
    }))
    tags = optional(map(string), {})
  }))
  default  = {}
  nullable = false

  validation {
    condition = alltrue([
      for k, v in var.peering_attachments :
      v.options == null || v.options.dynamic_routing == null || contains(["enable", "disable"], v.options.dynamic_routing)
    ])
    error_message = "`dynamic_routing` must be either `enable` or `disable`."
  }
}

variable "peering_attachment_accepters" {
  description = "Map of peering attachments created by another transit gateway to accept in this one"
  type = map(object({
    transit_gateway_attachment_id = string
    tags                          = optional(map(string), {})
  }))
  default  = {}
  nullable = false
}

variable "tgw_peering_attachment_tags" {
  description = "Additional tags for the peering attachments"
  type        = map(string)
  default     = {}
  nullable    = false
}
