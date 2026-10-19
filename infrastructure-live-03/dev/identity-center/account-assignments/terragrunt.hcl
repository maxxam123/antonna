include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/account-assignments.hcl"
  expose = true
}

# Pull outputs from the permission-sets stack dynamically
dependency "permission_sets" {
  config_path = "../permission-sets"
}

inputs = {
  # Map the external dependency values straight to the underlying variables
  permission_set_arns = dependency.permission_sets.outputs.permission_set_names_to_arns

  assignments = concat(
    include.envcommon.inputs.assignments,
    [
      {
        account_id          = "444455556666" # Dev / Sandbox Account
        group_name          = "Okta-Application-Developers"
        permission_set_name = "AdministratorAccess"
      },
      {
        account_id          = "999988887777" # Production Account
        group_name          = "Okta-Application-Developers"
        permission_set_name = "ReadOnlyAccess"
      }
    ]
  )
}
