output "tgw_id" {
  description = "EC2 Transit Gateway Identifier"
  value       = aws_ec2_transit_gateway.this.id
}

output "tgw_arn" {
  description = "EC2 Transit Gateway Amazon Resource Name"
  value       = aws_ec2_transit_gateway.this.arn
}

output "tgw_owner_id" {
  description = "Identifier of the AWS account that owns the Transit Gateway"
  value       = aws_ec2_transit_gateway.this.owner_id
}
