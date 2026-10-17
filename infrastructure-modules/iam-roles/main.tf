resource "aws_iam_role" "this" {
  for_each = var.iam_roles_config

  name                 = "${var.prefix}-${var.environment}-${each.key}-role"
  path                 = var.iam_path
  description          = each.value.description
  max_session_duration = var.max_session_duration

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = each.value.trusted_service
        }
      }
    ]
  })

  tags = merge(var.global_tags, {
    RoleGroup = "Application-Execution"
  })
}

resource "aws_iam_role_policy_attachment" "managed_policies" {
  for_each = {
    for pair in local.role_policy_attachments : "${pair.role_key}_${pair.policy_name}" => pair
  }

  role       = aws_iam_role.this[each.value.role_key].name
  policy_arn = each.value.policy_arn
}

resource "aws_iam_instance_profile" "this" {
  for_each = { for k, v in var.iam_roles_config : k => v if v.create_instance_profile }

  name = "${var.prefix}-${var.environment}-${each.key}-profile"
  role = aws_iam_role.this[each.key].name
  tags = var.global_tags
}
