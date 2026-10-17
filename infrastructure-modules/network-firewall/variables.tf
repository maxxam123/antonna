# infrastructure-modules/network-firewall/variables.tf

variable "prefix" {
  type        = string
  description = "Corporate standardized organizational prefix."
}

variable "environment" {
  type        = string
  description = "Deployment lifestyle stage (e.g., dev, prod)."
}

variable "vpc_id" {
  type        = string
  description = "The target AWS VPC ID."
}

variable "inspection_subnet_map" {
  type        = map(string)
  description = "Map of Availability Zones to Subnet IDs (e.g., {'us-east-1a' = 'subnet-123', 'us-east-1b' = 'subnet-456'})"
}

variable "log_group_name" {
  type        = string
  description = "The absolute namespace path for CloudWatch log collections."
}

variable "log_retention_in_days" {
  type        = number
  default     = 90
}

variable "log_destination_type" {
  type        = string
  default     = "CloudWatchLogs"
}

variable "firewall_policy_config" {
  type = object({
    stateless_default_actions          = list(string)
    stateless_fragment_default_actions = list(string)
    stateful_rule_group_references = list(object({
      priority     = number
      resource_arn = string
    }))
  })
  description = "Structural data blueprint describing traffic evaluation steps."
}

variable "global_tags" {
  type        = map(string)
  description = "Mandatory enterprise metadata tagging schemas."
}
