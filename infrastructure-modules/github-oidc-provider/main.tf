# 1. Fetch GitHub's OIDC TLS Certificate Thumbprint dynamically
data "aws_iam_openid_connect_provider" "github" {
  url = "https://githubusercontent.com"
}

# (Optional) If you don't want to fetch it dynamically, uncomment this resource:
# resource "aws_iam_openid_connect_provider" "github" {
#   url             = "https://githubusercontent.com"
#   client_id_list  = ["://amazonaws.com"]
#   thumbprint_list = ["1c58a3a8518e8759bf075b76b750d4f2df264fcd", "6938fd4d98bab03faadb97b34396831e3780aea1"]
# }

# 2. IAM Assume Role Trust Policy for GitHub Actions
data "aws_iam_policy_document" "github_oidc_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.github.arn]
    }

    # Restrict token access strictly to your GitHub organization and repositories
    condition {
      test     = "StringEquals"
      variable = "://githubusercontent.com:aud"
      values   = ["://amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "://githubusercontent.com:sub"
      values   = var.repositories
    }
  }
}

# 3. Create the deployment IAM Role
resource "aws_iam_role" "github_actions" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.github_oidc_assume.json
}

# 4. Attach policies to your OIDC Role
resource "aws_iam_role_policy_attachment" "custom_attachments" {
  for_each   = toset(var.oidc_role_attach_policies)
  role       = aws_iam_role.github_actions.name
  policy_arn = each.value
}
