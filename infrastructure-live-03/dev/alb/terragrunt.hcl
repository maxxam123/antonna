# infrastructure-live-03/dev/network/alb/terragrunt.hcl

# 1. Mount provider configurations from the absolute root
include "root" {
  path = find_in_parent_folders()
}

# 2. Extract shared baseline parameters from the common layout template
include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/alb.hcl"
  expose = true
}

# 3. Pull dynamic network footprints out of upstream deployment states
dependency "vpc" {
  config_path = "../vpc"
}

dependency "certificates" {
  config_path = "../../security/acm-certificates"
}

# 4. Supply context variables and runtime allocations
inputs = {
  environment = "dev"

  vpc_id = dependency.vpc.outputs.vpc_id
  
  # For internet-facing public ALBs, select your public edge subnet list outputs
  subnet_ids = dependency.vpc.outputs.public_subnet_ids
  
  # Pull the dynamic, valid SSL certificate verification token securely
  acm_certificate_arn = dependency.certificates.outputs.certificate_arn

  global_tags = merge(
    include.envcommon.inputs.global_tags,
    {
      Environment = "dev"
      CostCenter  = "NET-ROUTING-ALB-01"
    }
  )
}
