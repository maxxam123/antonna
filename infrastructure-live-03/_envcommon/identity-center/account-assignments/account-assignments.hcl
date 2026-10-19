terraform {
  source = "${dirname(find_in_parent_folders("root.hcl"))}/../modules//account-assignments"
}

inputs = {
  assignments = [
    {
      account_id          = "111122223333" # Management Target Account
      group_name          = "Okta-Platform-Engineers"
      permission_set_name = "AdministratorAccess"
    }
  ]
}
