# 1. Inherit global root configurations (S3 backend & AWS provider)
include "root" {
  path = find_in_parent_folders()
}

# 2. Inherit common TGW component layout and defaults
include "envcommon" {
  path = "${get_terragrunt_dir()}/../../_envcommon/tgw.hcl"
}

# 3. Override inputs for the Dev environment
inputs = {
  name            = "dev-transit-gateway"
  amazon_side_asn = 65002 # Custom ASN for Dev to prevent overlap with Prod/On-Prem

  tags = {
    Environment = "dev"
    Project     = "alpha"
  }
}
