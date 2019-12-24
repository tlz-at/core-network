# AWS Provider Variables
variable "region" {
  description = "AWS Region to deploy to"
  default     = "us-east-2"
}

variable "region_secondary" {
  description = "AWS secondary region to deploy to"
}

variable "role_name" {
  description = "AWS role name to assume"
  default     = "tlz_avm_automation"
}

# Account Variables
variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "assign_generated_ipv6_cidr_block" {
  description = "Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block"
  default     = false
}

variable "enable_s3_endpoint" {
  description = "Configure an S3 Endpoint on the VPC"
  default     = false
}

variable "enable_dynamodb_endpoint" {
  description = "Configure a DynamoDB Endpoint on the VPC"
  default     = false
}

variable "tfe_host_name" {
  description = "host_name for ptfe"
}

variable "tfe_org_name" {
  description = "ptfe organization name"
}

variable "tfe_avm_workspace_name" {
  description = "Name of avm workspace"
}

variable "tfe_core_logging_workspace_name" {
  description = "Name of logging workspace"
}

variable master_payer_account {
  description = "Master Payer Account Number"
}

variable master_payer_org_id {
  description = "AWS Organization ID"
}

variable account_id {
  description = "AWS Account ID"
}

variable account_type {
  description = "AWS Account Type"
}

variable okta_app_id {
  description = "Okta App ID"
}

variable name {
  description = "AWS Account Name"
}

variable okta_provider_domain {
  description = "Okta Provider Domain"
}

variable "okta_token" {
  type        = "string"
  description = "Okta API token (sensitive)"
}

variable "users_tlz_it_operations" {
  type        = "list"
  description = "list of user emails to provide access to this role (via okta)"
}

variable "users_tlz_intra_network" {
  type        = "list"
  description = "list of user emails to provide access to this role (via okta)"
}

variable "users_tlz_inter_network" {
  type        = "list"
  description = "list of user emails to provide access to this role (via okta)"
}

variable "users_tlz_admin" {
  type        = "list"
  description = "list of user emails to provide access to this role (via okta)"
}
