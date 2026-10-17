include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path = "${get_terragrunt_dir()}/../../_envcommon/tgw_attachment.hcl"
}

# Fetch the central router properties
dependency "tgw" {
  config_path = "../tgw"
}

# Fetch the target network properties
dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  name                   = "dev-vpc-to-tgw-link"
  transit_gateway_id     = dependency.tgw.outputs.tgw_id
  
  # Inject target network endpoints dynamically
  vpc_id                 = dependency.vpc.outputs.vpc_id
  subnet_ids             = dependency.vpc.outputs.private_subnets
  vpc_route_table_ids    = dependency.vpc.outputs.private_route_table_ids
  
  # Target destination routing parameter (e.g. GCP Subnet)
  destination_cidr_block = "10.200.0.0/16"
}
