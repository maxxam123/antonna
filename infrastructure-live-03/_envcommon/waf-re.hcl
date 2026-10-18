# _envcommon/waf_alb.hcl

terraform {
  source = "${get_repo_root()}//infrastructure-modules/waf"
}

inputs = {
  rate_limit_threshold = 3000

  # Standard core protections recommended for public-facing application load balancers
  managed_rules = [
    {
      name        = "AWSManagedRulesCommonRuleSet" # Covers OWASP Top 10 exploits
      priority    = 10
      vendor_name = "AWS"
    },
    {
      name        = "AWSManagedRulesAmazonIpReputationList" # Blocks known malicious IP addresses
      priority    = 20
      vendor_name = "AWS"
    }
  ]
}
