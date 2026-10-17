variable "name" {
  type        = string
  description = "Name tag for the Transit Gateway attachment"
}

variable "transit_gateway_id" {
  type        = string
  description = "The ID of the central Transit Gateway"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC to attach"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs from the VPC to place the TGW endpoints in"
}

variable "vpc_route_table_ids" {
  type        = list(string)
  description = "The IDs of the VPC Route Tables that need a path pointing to the TGW"
  default     = []
}

variable "destination_cidr_block" {
  type        = string
  description = "The external CIDR block (e.g. your GCP VPC range) to route through the TGW"
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resources"
  default     = {}
}
