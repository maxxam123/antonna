# infrastructure-modules/cloudfront/variables.tf

variable "prefix"                   { type = string }
variable "environment"              { type = string }
variable "global_tags"              { type = map(string) }
variable "origin_domain_name"       { type = string }
variable "origin_id"                { type = string }
variable "web_acl_id"               { type = string; default = null }

variable "price_class"              { type = string; default = "PriceClass_100" }
variable "minimum_protocol_version" { type = string; default = "TLSv1.2_2021" }
variable "min_ttl"                  { type = number; default = 0 }
variable "default_ttl"              { type = number; default = 86400 }
variable "max_ttl"                  { type = number; default = 31536000 }

variable "aliases" {
  type        = list(string)
  default     = []
  description = "Custom alternate DNS domain names attached directly to the CDN deployment distribution mapping."
}

variable "acm_certificate_arn" {
  type        = string
  default     = null
  description = "The Amazon Resource Name string mapping an active global edge SSL certificate."
}
