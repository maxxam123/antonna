# _envcommon/identity-center-users.hcl

locals {
  source_base_url = "git::git@github.com:your-org/terraform-modules.git//identity-center-users"
}

terraform {
  source = "${local.source_base_url}?ref=v1.3.0"
}

inputs = {
  users = {
    breakglass_admin = {
      user_name   = "breakglass.admin"
      given_name  = "BreakGlass"
      family_name = "Admin"
      email       = "security-ops@company.com"
    }
  }
}
