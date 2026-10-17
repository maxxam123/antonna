include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path = "${get_terragrunt_dir()}/../../_envcommon/ec2.hcl"
}

inputs = {
  name          = "dev-app-server"
  instance_type = "t3.small"

  tags = {
    Environment = "dev"
    Project     = "alpha"
  }
}
