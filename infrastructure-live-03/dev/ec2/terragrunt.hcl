terraform {
  source = "../../../infrastructure-modules/ec2"
}

include  "root" {
  path = find_in_parent_folders()
}

input = {
  env = "dev"
  azs = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.0.0/19", "10.0.32.0/19"]
  public_subnets = ["10.0.64.0/19", "10.0.96.0/19"] 
}
