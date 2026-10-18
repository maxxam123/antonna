# infrastructure-modules/alb/outputs.tf

output "alb_id" {
  description = "The direct unique resource ID assigned to the load balancer."
  value       = aws_lb.this.id
}

output "alb_arn" {
  description = "The canonical Amazon Resource Name string tracking the load balancer endpoint. 👈 REQUIRED BY WAF."
  value       = aws_lb.this.arn
}

output "alb_dns_name" {
  description = "The auto-generated public AWS record hostname link."
  value       = aws_lb.this.dns_name
}

output "alb_zone_id" {
  description = "The canonical hosted zone identifier mapping the ALB grid routing system (Used for DNS alias mapping)."
  value       = aws_lb.this.zone_id
}

output "https_listener_arn" {
  description = "The ARN of the secure HTTPS listener block (Used by downstream compute apps to append target groups)."
  value       = aws_lb_listener.https.arn
}
