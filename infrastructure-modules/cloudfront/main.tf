# infrastructure-modules/cloudfront/main.tf

# --------------------------------------------------------------------------------------------------
# 1. ORIGIN ACCESS CONTROL / BINDINGS
# --------------------------------------------------------------------------------------------------
# (Optional configuration tracking if you switch from ALB to an origin S3 bucket setup later)
resource "aws_cloudfront_origin_access_control" "this" {
  name                              = "${var.prefix}-${var.environment}-oac"
  description                       = "Enterprise Origin Access Control policy setup"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# --------------------------------------------------------------------------------------------------
# 2. CORE AMAZON CLOUDFRONT DISTRIBUTION
# --------------------------------------------------------------------------------------------------
resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Managed by Terragrunt IaC. ${var.prefix} core routing engine."
  price_class         = var.price_class
  aliases             = var.aliases
  web_acl_id          = var.web_acl_id # Attaches the global edge firewall

  # The backend structural entry point definitions
  origin {
    domain_name = var.origin_domain_name
    origin_id   = var.origin_id

    # If your origin target is a standard Application Load Balancer
    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_protocol_policy   = "https-only" # Enforces absolute in-transit encryption
      origin_ssl_protocols     = ["TLSv1.2"]
    }
  }

  # Default cache behavior mapping rulesets
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.origin_id

    # Forwards headers securely to allow applications to receive contextual host headers
    forwarded_values {
      query_string = true
      headers      = ["Host", "Authorization"]

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https" # Strictly enforce secure entrypoint connections
    min_ttl                = var.min_ttl
    default_ttl            = var.default_ttl
    max_ttl                = var.max_ttl
  }

  # Mandatory routing geolocation behavior boundaries
  restrictions {
    geo_restriction {
      restriction_type = "none" # Use your attached WAF module rules to geo-block instead
    }
  }

  # SSL/TLS Distribution Certificates Binding Block
  viewer_certificate {
    cloudfront_default_certificate = length(var.aliases) == 0 ? true : false
    acm_certificate_arn            = length(var.aliases) > 0 ? var.acm_certificate_arn : null
    ssl_support_method             = length(var.aliases) > 0 ? "sni-only" : null
    minimum_protocol_version       = var.minimum_protocol_version
  }

  tags = merge(
    var.global_tags,
    {
      Name = "${var.prefix}-${var.environment}-cdn"
    }
  )
}
