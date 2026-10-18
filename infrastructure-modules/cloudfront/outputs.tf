# infrastructure-modules/cloudfront/outputs.tf

output "cloudfront_id" {
  description = "The static operational unique identifier mapping the CDN system grid."
  value       = aws_cloudfront_distribution.this.id
}

output "cloudfront_domain_name" {
  description = "The native auto-assigned Amazon canonical hostname url domain (e.g., d111111abcdef8.cloudfront.net)."
  value       = aws_cloudfront_distribution.this.domain_name
}

output "cloudfront_hosted_zone_id" {
  description = "The canonical Route 53 global hosted allocation mapping zone code identifier (Used for DNS alias binding loops)."
  value       = aws_cloudfront_distribution.this.hosted_zone_id
}
