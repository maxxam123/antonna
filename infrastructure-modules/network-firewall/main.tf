resource "aws_cloudwatch_log_group" "nfw_logs" {
  name              = var.log_group_name
  retention_in_days = var.log_retention_in_days

  tags = merge(var.global_tags, {
    Component = "Firewall-Logging-Engine"
  })
}

resource "aws_networkfirewall_firewall_policy" "this" {
  name = "${var.prefix}-${var.environment}-nfw-policy"

  firewall_policy {
    stateless_default_actions          = var.firewall_policy_config.stateless_default_actions
    stateless_fragment_default_actions = var.firewall_policy_config.stateless_fragment_default_actions

    dynamic "stateful_rule_group_reference" {
      for_each = var.firewall_policy_config.stateful_rule_group_references
      content {
        priority     = stateful_rule_group_reference.value.priority
        resource_arn = stateful_rule_group_reference.value.resource_arn
      }
    }
  }

  tags = var.global_tags
}

resource "aws_networkfirewall_firewall" "this" {
  name                = "${var.prefix}-${var.environment}-nfw"
  vpc_id              = var.vpc_id
  firewall_policy_arn = aws_networkfirewall_firewall_policy.this.arn

  # Dynamically attach an asymmetric sync endpoint endpoint to each subnet provided in the map
  dynamic "subnet_mapping" {
    for_each = var.inspection_subnet_map
    content {
      subnet_id = subnet_mapping.value
    }
  }

  tags = merge(
    var.global_tags,
    {
      Name = "${var.prefix}-${var.environment}-nfw-appliance"
    }
  )
}

resource "aws_networkfirewall_logging_configuration" "this" {
  firewall_arn = aws_networkfirewall_firewall.this.arn

  logging_configuration {
    log_destination_config {
      log_destination = {
        logGroup = aws_cloudwatch_log_group.nfw_logs.name
      }
      log_destination_type = var.log_destination_type
      log_type             = "FLOW"
    }
    log_destination_config {
      log_destination = {
        logGroup = aws_cloudwatch_log_group.nfw_logs.name
      }
      log_destination_type = var.log_destination_type
      log_type             = "ALERT"
    }
  }
}
