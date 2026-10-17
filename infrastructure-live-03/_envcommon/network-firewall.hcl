include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/network-firewall.hcl"
  expose = true
}

dependency "vpc" {
  config_path = "../../vpc"
}

inputs = {
  prefix      = "acme"
  environment = "dev"

  vpc_id                = dependency.vpc.outputs.vpc_id

  inspection_subnet_map = dependency.vpc.outputs.inspection_subnet_ids_map

  log_group_name = "/aws/network-firewall/acme-dev-inspection-logs"

  global_tags = merge(
    include.envcommon.inputs.global_tags,
    {
      Environment = "dev"
      CostCenter  = "SEC-OPS-7711"
    }
  )
}
