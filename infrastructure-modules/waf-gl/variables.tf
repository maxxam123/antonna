# infrastructure-modules/waf-cloudfront/variables.tf

variable "prefix"      { type = string }
variable "environment" { type = string }
variable "aws_region"  { type = string }
variable "global_tags" { type = map(string) }

variable "rate_limit_threshold" {
  type        = number
  default     = 1000
  description = "Maximum rolling 5-minute request count threshold per individual source IP address."
}

variable "managed_rules" {
  type = list(object({
    name        = string
    priority    = number
    vendor_name = string
  }))
}
