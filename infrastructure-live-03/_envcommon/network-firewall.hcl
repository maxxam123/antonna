# infrastructure-live-03/dev/network-firewall/terragrunt.hcl

# 1. Inherit root provider configurations and remote state setup
include "root" {
  path = find_in_parent_folders()
}

# 2. Pull down base configurations and policy engine metadata
include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/network_firewall.hcl"
  expose = true
}

# 3. Dynamic binding to the base VPC component
dependency "vpc" {
  config_path = "../vpc"
}

# 4. Inject development-specific routing and environment overrides
inputs = {
  prefix      = "acme"
  environment = "dev"

  # Pass down structural variables directly out of VPC outputs
  vpc_id                = dependency.vpc.outputs.vpc_id
  
  # Pass a map of inspection subnets (e.g., {"eu-central-1a" = "subnet-xxx", "eu-central-1b" = "subnet-yyy"})
  # The module uses this map to create individual firewall endpoints per AZ
  inspection_subnet_map = dependency.vpc.outputs.inspection_subnet_ids_map

  # Append development network constraints to the default logging groups
  log_group_name = "/aws/network-firewall/acme-dev-inspection-logs"

  # Merge environment-specific context onto the common global tags
  global_tags = merge(
    include.envcommon.inputs.global_tags,
    {
      Environment = "dev"
      CostCenter  = "SEC-OPS-7711"
    }
  )
}
