terraform {
  source = "${get_repo_root()}//infrastructure-modules/network-firewall"
}

inputs = {
  enable_logging             = true
  log_destination_type       = "CloudWatchLogs"
  log_retention_in_days      = 90

  firewall_policy_config = {
    stateless_default_actions      = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]
    
    stateful_rule_group_references = [
      { priority = 10, resource_arn = "arn:aws:network-firewall:us-east-1:aws:managed-stateful/AbusedLegitBotNetCommandAndControlDomains" },
      { priority = 20, resource_arn = "arn:aws:network-firewall:us-east-1:aws:managed-stateful/MalwareDomains" }
    ]
  }

  global_tags = {
    ManagedBy          = "Terragrunt-IaC"
    ArchitectureLayer   = "Network-Security"
    DataClassification = "Strictly-Confidential"
  }
}
