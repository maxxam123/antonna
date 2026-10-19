# main.tf
data "aws_ssoadmin_instances" "this" {}

locals {
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)
}

variable "groups" {
  type        = list(string)
  description = "List of Identity Store group names to create"
}

variable "memberships" {
  type = list(object({
    group_name = string
    user_id    = string
  }))
  description = "List of group memberships mapping group name to explicit user IDs"
  default     = []
}

# 1. Create the Directory Groups
resource "aws_identitystore_group" "this" {
  for_each          = toset(var.groups)
  identity_store_id = local.identity_store_id
  display_name      = each.value
  description       = "Managed by Terragrunt"
}

# 2. Bind Users to the newly created Groups
resource "aws_identitystore_group_membership" "this" {
  for_each = {
    for idx, member in var.memberships : "${member.group_name}-${member.user_id}" => member
  }

  identity_store_id = local.identity_store_id
  group_id          = aws_identitystore_group.this[each.value.group_name].group_id
  member_id         = each.value.user_id
}

# Output group names mapped to their generated Group IDs for downstream assignment usage
output "group_ids" {
  value = { for k, v in aws_identitystore_group.this : k => v.group_id }
}

