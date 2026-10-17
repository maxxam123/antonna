variable "env" {
  description = "Env name"
  type = string
}

variable "vpc_cidr_block" {
  description = "CIDR name"
  type = string
  default = "10.0.0.0/16"
}

variable "azs" {
  description = "azs name"
  type = list(string)
}

variable "private_subnets" {
  description = "private subnet name"
  type = list(string)
}

variable "public_subnets" {
  description = "public subnet name"
  type = list(string)
}

variable "private_subnet_tags" {
  description = "private subnet tags"
  type = may(any)
}

variable "public_subnet_tags" {
  description = "public subnet tags"
  type = may(any)
}
