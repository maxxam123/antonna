variable "env" {
  description = "Env name"
  type = string
}

variable "vpc_cidr_block" {
  description = "CIDR name"
  type = string
  default = "10.0.0.0/16"
}
