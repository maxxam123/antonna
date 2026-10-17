terraform {
  source = "${get_repo_root()}/modules/tgwa"
}

inputs = {
  tags = {
    Terraform   = "true"
    ManagedBy   = "Terragrunt"
    Component   = "Networking-Attachment"
  }
}
