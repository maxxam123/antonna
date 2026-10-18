# infrastructure-modules/waf-cloudfront/outputs.tf

output "web_acl_id" {
  description = "The unique identification string mapping the WAF cluster."
  value       = aws_wafv2_web_acl.this.id
}

output "web_acl_arn" {
  description = "The Amazon Resource Name of the Web ACL. 👈 PASS THIS TO CLOUDFRONT."
  value       = aws_wafv2_web_acl.this.arn
}
