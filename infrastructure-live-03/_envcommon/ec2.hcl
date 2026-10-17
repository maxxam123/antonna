terraform {
  source = "../../../infrastructure-modules/ec2"
}

inputs = {
  name           = "app-server"
  ami            = "ami-0c7217cdde317cfec"
  instance_type  = "t3.micro"
  monitoring     = true

  tags = {
    Terraform   = "true"
    ManagedBy   = "Terragrunt"
  }
}
