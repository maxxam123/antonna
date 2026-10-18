remote_state {
  backend = "local"
  generate = {
    path = "backend.tf"
    tf_exists = "overwrite_terragrunt"
  }

  config = {
    path = "${path_relative_to_include()}/terraform.trstate"
  }
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"

  contents = <<EOF
provider "aws" {
  region = "us-east-1"
  # region = "${contains(split("/", get_terragrunt_dir()), "waf-global") ? "us-east-1" : "eu-west-1"}"
}
EOF
}
