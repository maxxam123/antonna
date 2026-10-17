# _envcommon/iam_roles.hcl
terraform {
  source = "${get_repo_root()}//infrastructure-modules/iam-roles"
}

inputs = {
  iam_path             = "/application/"
  max_session_duration = 43200 # 12 Hours
}
