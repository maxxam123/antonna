# infrastructure-modules/iam-roles/variables.tf

variable "prefix" { type = string }
variable "environment" { type = string }
variable "global_tags" { type = map(string) }

variable "iam_path" {
  type        = string
  default     = "/delegated/"
  description = "Standardized corporate IAM path namespace for organizational governance."
}

variable "max_session_duration" {
  type        = number
  default     = 3600
}

variable "iam_roles_config" {
  type = map(object({
    description             = string
    trusted_service         = string
    create_instance_profile = bool
    managed_policy_arns     = map(string)
  }))
  description = "A complex inventory map defining enterprise roles and their default system permissions."
}
