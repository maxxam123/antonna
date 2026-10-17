include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path = "${get_terragrunt_dir()}/../../_envcommon/ec2.hcl"
}

dependency "s3" {
  config_path = "../../s3"
}

inputs = {
  s3_bucket_name = dependency.s3.outputs.s3_bucket_id
  instance_type = "t3.small"

  tags = {
    Environment = "dev"
    Project     = "alpha"
  }
}
