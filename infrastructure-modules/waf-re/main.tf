# infrastructure-modules/waf/main.tf

# --------------------------------------------------------------------------------------------------
# 1. REGIONAL WEB APPLICATION FIREWALL (ALB Scope)
# --------------------------------------------------------------------------------------------------
resource "aws_wafv2_web_acl" "this" {
  name        = "${var.prefix}-${var.environment}-regional-waf"
  description = "Regional perimeter firewall guarding application load balancers against Layer 7 exploits."
  scope       = "REGIONAL" # 👈 Explicitly set to REGIONAL for ALB bindings

  default_action {
    allow {}
  }

  # Dynamic block iterating through baseline AWS Managed Rules
  dynamic "rule" {
    for_each = var.managed_rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      override_action {
        none {}
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

  # Custom Ingress Rate Limiter (Protects ALB targets from credential stuffing / brute force loops)
  rule {
    name     = "CorporateALBRateLimit"
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
      metric_name                = "${var.prefix}-${var.environment}-ALBRateLimit-metric"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.prefix}-${var.environment}-regional-webacl-main-metric"
    sampled_requests_enabled   = true
  }

  tags = var.global_tags
}

# --------------------------------------------------------------------------------------------------
# 2. AUTOMATED WAF-TO-ALB ASSOCIATION BINDING
# --------------------------------------------------------------------------------------------------
# This connects the WAF policy instantly to the physical hardware interface of your load balancer
resource "aws_wafv2_web_acl_association" "alb" {
  resource_arn = var.target_alb_arn
  web_acl_arn  = aws_wafv2_web_acl.this.arn
}
