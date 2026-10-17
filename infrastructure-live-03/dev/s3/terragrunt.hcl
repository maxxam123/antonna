# 1. Inherit global root configurations (S3 backend & AWS provider)
include "root" {
  path = find_in_parent_folders()
}

# 2. Inherit common S3 component layout and defaults
include "envcommon" {
  path = "${get_terragrunt_dir()}/../../_envcommon/s3.hcl"
}

# 3. Override inputs for the Dev environment to maintain unique names
inputs = {
  bucket        = "my-company-dev-app-data-bucket" # Globally unique bucket name
  force_destroy = true                             # Safe to wipe data on destroy in Dev

  tags = {
    Environment = "dev"
    Project     = "alpha"
  }
}
