# main.tf
data "aws_ssoadmin_instances" "this" {}

locals {
  sso_instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]
}

variable "permission_sets" {
  type = map(object({
    description      = string
    session_duration = string
    managed_policies = list(string)
    inline_policy    = string
  }))
}

resource "aws_ssoadmin_permission_set" "this" {
  for_each         = var.permission_sets
  name             = each.key
  description      = each.value.description
  instance_arn     = local.sso_instance_arn
  session_duration = each.value.session_duration
}

resource "aws_ssoadmin_managed_policy_attachment" "this" {
  # Flatten out permission sets and their list of managed policies
  for_each = merge([
    for ps_name, ps_data in var.permission_sets : {
      for policy in ps_data.managed_policies : "${ps_name}-${policy}" => {
        permission_set_arn = aws_ssoadmin_permission_set.this[ps_name].arn
        policy_arn         = policy
      }
    }
  ]...)

  instance_arn       = local.sso_instance_arn
  permission_set_arn = each.value.permission_set_arn
  managed_policy_arn = each.value.policy_arn
}

resource "aws_ssoadmin_permission_set_inline_policy" "this" {
  for_each = {
    for k, v in var.permission_sets : k => v if v.inline_policy != ""
  }

  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this[each.key].arn
  inline_policy      = each.value.inline_policy
}

