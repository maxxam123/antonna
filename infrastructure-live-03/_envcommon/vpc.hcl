terraform {
  source = "../../../infrastructure-modules/vpc"
}

inputs = {
  env = "dev"
  name           = "name"

  tags = {
    Terraform   = "true"
    ManagedBy   = "Terragrunt"
  }
}
