terraform {
  source = "../../../infrastructure-modules/vpc"
}

inputs = {
  name           = "name"

  tags = {
    Terraform   = "true"
    ManagedBy   = "Terragrunt"
  }
}
