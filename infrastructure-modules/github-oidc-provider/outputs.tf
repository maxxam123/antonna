output "role_arn" {
  value       = aws_iam_role.github_actions.arn
  description = "The exact ARN string to pass to your actions/configure-aws-credentials step"
}
