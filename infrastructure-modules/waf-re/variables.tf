# infrastructure-modules/waf/variables.tf

variable "prefix"               { type = string }
variable "environment"          { type = string }
variable "global_tags"          { type = map(string) }
variable "target_alb_arn"       { type = string; description = "The explicit Amazon Resource Name mapping your target ALB." }
variable "rate_limit_threshold" { type = number; default = 2000 }

variable "managed_rules" {
  type = list(object({
    name        = string
    priority    = number
    vendor_name = string
  }))
}
