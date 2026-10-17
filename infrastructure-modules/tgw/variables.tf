variable "name" {
  type        = string
  description = "Name tag for the Transit Gateway"
}

variable "description" {
  type        = string
  description = "Description of the Transit Gateway"
  default     = null
}

variable "amazon_side_asn" {
  type        = number
  description = "Private Autonomous System Number (ASN) for the Amazon side of a BGP session"
  default     = 64512
}

variable "auto_accept_shared_attachments" {
  type        = string
  description = "Whether resource attachment requests are automatically accepted. (enable/disable)"
  default     = "disable"
}

variable "default_route_table_association" {
  type        = string
  description = "Whether resource attachments are automatically associated with the default route table. (enable/disable)"
  default     = "enable"
}

variable "default_route_table_propagation" {
  type        = string
  description = "Whether resource attachments automatically propagate routes to the default route table. (enable/disable)"
  default     = "enable"
}

variable "tags" {
  type        = map(string)
  description = "Key-value tags for the resource"
  default     = {}
}
