# infrastructure-modules/waf-cloudfront/main.tf

# --------------------------------------------------------------------------------------------------
# 1. AWS WAFV2 WEB ACL DEFINITION (CLOUDFRONT SCOPED)
# --------------------------------------------------------------------------------------------------
resource "aws_wafv2_web_acl" "this" {
  name        = "${var.prefix}-${var.environment}-cloudfront-waf"
  description = "Edge perimeter firewall guarding CloudFront distributions against Layer 7 attacks."
  scope       = "CLOUDFRONT" # 👈 Mandatory scope flag

  default_action {
    allow {}
  }

  # Dynamic block iterating through the standard AWS Managed Rules matrix
  dynamic "rule" {
    for_each = var.managed_rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      override_action {
        none {} # Do not override; let the rule groups block attacks actively
      }

      statement {
        managed_rule_group_statement {
          name        = rule.value.name
          vendor_name = rule.value.vendor_name
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "${var.prefix}-${var.environment}-${rule.value.name}-metric"
        sampled_requests_enabled   = true
      }
    }
  }

  # Custom Enterprise Rule: Layer 7 DDOS / Excessive Ingress Rate Limiter
  rule {
    name     = "CorporateCustomRateLimit"
    priority = 100

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = var.rate_limit_threshold
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.prefix}-${var.environment}-RateLimit-metric"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.prefix}-${var.environment}-webacl-main-metric"
    sampled_requests_enabled   = true
  }

  tags = var.global_tags
}
