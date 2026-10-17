# Define the source of your custom local TGW module
terraform {
  source = "${get_repo_root()}/modules/tgw"
}

# Define base inputs that every environment shares by default
inputs = {
  name                             = "main-transit-gateway"
  description                      = "Transit Gateway for cross-VPC and hybrid cloud routing"
  amazon_side_asn                  = 64512 # Standard private ASN baseline
  auto_accept_shared_attachments   = "enable"
  default_route_table_association  = "enable"
  default_route_table_propagation  = "enable"

  tags = {
    Terraform   = "true"
    ManagedBy   = "Terragrunt"
    Component   = "Networking"
  }
}
