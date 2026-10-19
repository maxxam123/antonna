# main.tf
data "aws_ssoadmin_instances" "this" {}

locals {
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
}

variable "users" {
  type = map(object({
    user_name    = string
    given_name   = string
    family_name  = string
    email        = string
  }))
  description = "Map of local users to create in AWS Identity Store"
}

resource "aws_identitystore_user" "this" {
  for_each          = var.users
  identity_store_id = local.identity_store_id

  user_name    = each.value.user_name
  display_name = "${each.value.given_name} ${each.value.family_name}"

  name {
    given_name  = each.value.given_name
    family_name = each.value.family_name
  }

  emails {
    value   = each.value.email
    primary = true
  }
}

# Output user names mapped to their generated Identity Store IDs for group membership usage
output "user_ids" {
  value = { for k, v in aws_identitystore_user.this : k => v.user_id }
}

