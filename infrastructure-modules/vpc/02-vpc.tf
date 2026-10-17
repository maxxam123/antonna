resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr_block   # From 08-variables.tf

  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.env}-main"  # From 08-var -> infrastructure-live-03/dev/vpc/terragrunt.hcl
}
