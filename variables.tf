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

variable "transit_gateway_cidr_blocks" {
  description = "One or more IPv4 or IPv6 CIDR blocks for the transit gateway. Must be a size /24 CIDR block or larger for IPv4, or a size /64 CIDR block or larger for IPv6"
  type        = list(string)
  default     = []
}

variable "timeouts" {
  description = "Create, update, and delete timeout configurations for the transit gateway"
  type        = map(string)
  default     = {}
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
# Flow Log
################################################################################

variable "enable_flow_log" {
  description = "Whether or not to enable TGW Flow Logs"
  type        = bool
  default     = false
}

variable "create_flow_log_cloudwatch_iam_role" {
  description = "Whether to create IAM role for TGW Flow Logs"
  type        = bool
  default     = false
}

variable "create_flow_log_cloudwatch_log_group" {
  description = "Whether to create CloudWatch log group for TGW Flow Logs"
  type        = bool
  default     = false
}

variable "flow_log_destination_type" {
  description = "Type of flow log destination. Can be s3, kinesis-data-firehose or cloud-watch-logs"
  type        = string
  default     = "cloud-watch-logs"
}

variable "flow_log_destination_arn" {
  description = "The ARN of the CloudWatch log group or S3 bucket where TGW Flow Logs will be pushed. If this ARN is a S3 bucket the appropriate permissions need to be set on that bucket's policy. When create_flow_log_cloudwatch_log_group is set to false this argument must be provided"
  type        = string
  default     = ""
}

variable "flow_log_log_format" {
  description = "The fields to include in the flow log record, in the order in which they should appear"
  type        = string
  default     = null
}

variable "flow_log_traffic_type" {
  description = "The type of traffic to capture. Valid values: ACCEPT, REJECT, ALL"
  type        = string
  default     = "ALL"
}

variable "flow_log_max_aggregation_interval" {
  description = "The maximum interval of time during which a flow of packets is captured and aggregated into a flow log record. Valid Values: `60` seconds"
  type        = number
  default     = 60
}

variable "flow_log_deliver_cross_account_role" {
  description = "(Optional) ARN of the IAM role that allows Amazon EC2 to publish flow logs across accounts."
  type        = string
  default     = null
}

variable "flow_log_file_format" {
  description = "(Optional) The format for the flow log. Valid values: `plain-text`, `parquet`"
  type        = string
  default     = null
}

variable "flow_log_hive_compatible_partitions" {
  description = "(Optional) Indicates whether to use Hive-compatible prefixes for flow logs stored in Amazon S3"
  type        = bool
  default     = false
}

variable "flow_log_per_hour_partition" {
  description = "(Optional) Indicates whether to partition the flow log per hour. This reduces the cost and response time for queries"
  type        = bool
  default     = false
}

variable "flow_log_cloudwatch_iam_role_arn" {
  description = "The ARN for the IAM role that's used to post flow logs to a CloudWatch Logs log group. When flow_log_destination_arn is set to ARN of Cloudwatch Logs, this argument needs to be provided"
  type        = string
  default     = ""
}

variable "flow_log_cloudwatch_iam_role_conditions" {
  description = "Additional conditions of the CloudWatch role assumption policy"
  type = list(object({
    test     = string
    variable = string
    values   = list(string)
  }))
  default = []
}

variable "flow_log_cloudwatch_log_group_name_prefix" {
  description = "Specifies the name prefix of CloudWatch Log Group for TGW flow logs"
  type        = string
  default     = "/aws/tgw-flow-log/"
}

variable "flow_log_cloudwatch_log_group_name_suffix" {
  description = "Specifies the name suffix of CloudWatch Log Group for TGW flow logs"
  type        = string
  default     = ""
}

variable "flow_log_cloudwatch_log_group_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group for TGW flow logs"
  type        = number
  default     = null
}

variable "flow_log_cloudwatch_log_group_kms_key_id" {
  description = "The ARN of the KMS Key to use when encrypting log data for TGW flow logs"
  type        = string
  default     = null
}

variable "flow_log_cloudwatch_log_group_skip_destroy" {
  description = "Set to true if you do not wish the log group (and any logs it may contain) to be deleted at destroy time, and instead just remove the log group from the Terraform state"
  type        = bool
  default     = false
}

variable "flow_log_cloudwatch_log_group_class" {
  description = "Specified the log class of the log group. Possible values are: STANDARD or INFREQUENT_ACCESS"
  type        = string
  default     = null
}

variable "tgw_flow_log_iam_role_name" {
  description = "Name to use on the TGW Flow Log IAM role created"
  type        = string
  default     = "tgw-flow-log-role"
}

variable "tgw_flow_log_iam_role_use_name_prefix" {
  description = "Determines whether the IAM role name (`tgw_flow_log_iam_role_name`) is used as a prefix"
  type        = bool
  default     = true
}

variable "tgw_flow_log_permissions_boundary" {
  description = "The ARN of the Permissions Boundary for the TGW Flow Log IAM Role"
  type        = string
  default     = null
}

variable "tgw_flow_log_iam_policy_name" {
  description = "Name of the IAM policy"
  type        = string
  default     = "tgw-flow-log-to-cloudwatch"
}

variable "tgw_flow_log_iam_policy_use_name_prefix" {
  description = "Determines whether the name of the IAM policy (`tgw_flow_log_iam_policy_name`) is used as a prefix"
  type        = bool
  default     = true
}

variable "tgw_flow_log_tags" {
  description = "Additional tags for the TGW Flow Logs"
  type        = map(string)
  default     = {}
}
