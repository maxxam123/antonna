# infrastructure-modules/network-firewall/outputs.tf

output "firewall_id" {
  description = "The ARN identifier mapping the firewall instance."
  value       = aws_networkfirewall_firewall.this.id
}

output "firewall_status" {
  description = "The raw cloud runtime status block from the engine."
  value       = aws_networkfirewall_firewall.this.firewall_status
}

output "endpoint_map_by_az" {
  description = "Highly-optimized dictionary parsing Sync Endpoint IDs indexed by AZ string keys for downstream route generation."
  value = {
    # Loops over the dynamic map array nested inside the sync state data block
    for sync_state in aws_networkfirewall_firewall.this.firewall_status[0].sync_states : 
    sync_state.availability_zone => sync_state.attachment[0].endpoint_id
    if sync_state.attachment != null && length(sync_state.attachment) > 0
  }
}
