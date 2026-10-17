output "attachment_id" {
  description = "The ID of the Transit Gateway VPC Attachment"
  value       = aws_ec2_transit_gateway_vpc_attachment.this.id
}
