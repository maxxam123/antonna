variable "role_name" {
  type        = string
  description = "Name of the IAM Role created for GitHub Actions execution"
}

variable "repositories" {
  type        = list(string)
  description = "List of allowed GitHub repositories formatted as repo:org/name:*"
}

variable "oidc_role_attach_policies" {
  type        = list(string)
  default     = []
  description = "ARNs of AWS Managed policies to bind to the runner role"
}
