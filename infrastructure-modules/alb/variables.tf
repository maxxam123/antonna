# infrastructure-modules/alb/variables.tf

variable "prefix"                 { type = string }
variable "environment"            { type = string }
variable "global_tags"            { type = map(string) }
variable "vpc_id"                 { type = string }
variable "subnet_ids"             { type = list(string); description = "Public subnets if internet-facing, private subnets if internal." }
variable "acm_certificate_arn"     { type = string; description = "The explicit Amazon Resource Name token for the domain TLS certificate." }

variable "internal_load_balancer" { type = bool; default = false }
variable "ssl_policy"             { type = string; default = "ELBSecurityPolicy-TLS13-1-2-2021-06" }
