# infrastructure-live-03/dev/security/waf-alb/terragrunt.hcl

# 1. Pull core provider setup and state pointers from the absolute root
include "root" {
  path = find_in_parent_folders()
}

# 2. Inherit the standardized SecOps rules definitions 
include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/waf_alb.hcl"
  expose = true
}

# 3. Establish strict execution order dependency to fetch your live ALB endpoint
dependency "alb" {
  config_path = "../../network/alb"
}

# 4. Bind parameters and map the outputs cleanly
inputs = {
  environment = "dev"
  aws_region  = include.root.inputs.aws_region # Sits in the exact same region as your ALB

  # Extracted dynamically from your live network component layer outputs
  target_alb_arn = dependency.alb.outputs.alb_arn

  global_tags = merge(
    include.envcommon.inputs.global_tags,
    {
      Environment = "dev"
      CostCenter  = "SEC-ALB-FIREWALL-11"
    }
  )
}

