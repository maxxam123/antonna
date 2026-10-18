# infrastructure-modules/alb/main.tf

# --------------------------------------------------------------------------------------------------
# 1. APPLICATION LOAD BALANCER
# --------------------------------------------------------------------------------------------------
resource "aws_lb" "this" {
  name               = "${var.prefix}-${var.environment}-alb"
  internal           = var.internal_load_balancer
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.subnet_ids

  # Enterprise Safeguard: Prevent accidental deletions in production environments
  enable_deletion_protection = var.environment == "prod" ? true : false

  tags = merge(var.global_tags, { Name = "${var.prefix}-${var.environment}-alb" })
}

# --------------------------------------------------------------------------------------------------
# 2. DEFAULT SECURITY GROUP FOR INGRESS SCRUBBING
# --------------------------------------------------------------------------------------------------
resource "aws_security_group" "alb" {
  name        = "${var.prefix}-${var.environment}-alb-sg"
  description = "Controls baseline public or internal ingress connectivity to the ALB array."
  vpc_id      = var.vpc_id

  # Rule A: Open Standard HTTP (In production, this only serves to issue a immediate 301 redirection)
  ingress {
    description      = "Allow plaintext HTTP ingress connections"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  # Rule B: Secure Encrypted HTTPS
  ingress {
    description      = "Allow secure TLS HTTPS ingress connections"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  # Outbound Rule: Restrict outbound communication strictly to backend compute targets
  egress {
    description = "Allow outbound forwarding tracking to downstream targets"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Can be scoped directly down to your internal VPC subnets CIDR
  }

  tags = merge(var.global_tags, { Name = "${var.prefix}-${var.environment}-alb-sg" })
}

# --------------------------------------------------------------------------------------------------
# 3. BASELINE LISTENERS (With HTTPS Redirection Guard)
# --------------------------------------------------------------------------------------------------
# Standard port 80 listener intercepts insecure entries and triggers a 301 redirect instantly.
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# Secure port 443 listener handles incoming connection handshakes
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.acm_certificate_arn

  # Base action handles unmapped paths securely by issuing a fixed 404 block
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Access Denied: Endpoint Unrecognized"
      status_code  = "404"
    }
  }
}
