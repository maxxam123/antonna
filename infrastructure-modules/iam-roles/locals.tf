locals {
  role_policy_attachments = flatten([
    for role_key, config in var.iam_roles_config : [
      for policy_name, policy_arn in config.managed_policy_arns : {
        role_key    = role_key
        policy_name = policy_name
        policy_arn  = policy_arn
      }
    ]
  ])
}
