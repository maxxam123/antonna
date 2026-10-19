data "aws_ssoadmin_instances" "this" {}

locals {
  instance_arn      = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
}

variable "assignments" {
  type = list(object({
    account_id          = string
    group_name          = string
    permission_set_name = string
  }))
}

variable "permission_set_arns" {
  type        = map(string)
  description = "Map of permission set names to their AWS ARNs"
}

data "aws_identitystore_group" "lookup" {
  for_each          = { for a in var.assignments : a.group_name => a... }
  identity_store_id = local.identity_store_id

  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = each.key
    }
  }
}

resource "aws_ssoadmin_account_assignment" "this" {
  for_each = { for idx, a in var.assignments : "${a.account_id}-${a.group_name}-${a.permission_set_name}" => a }

  instance_arn       = local.instance_arn
  target_id          = each.value.account_id
  target_type        = "AWS_ACCOUNT"
  principal_type     = "GROUP"
  principal_id       = data.aws_identitystore_group.lookup[each.value.group_name].id
  permission_set_arn = var.permission_set_arns[each.value.permission_set_name]
}

