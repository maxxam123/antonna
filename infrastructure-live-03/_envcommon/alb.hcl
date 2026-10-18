# _envcommon/alb.hcl

terraform {
  source = "${get_repo_root()}//infrastructure-modules/alb"
}

inputs = {
  internal_load_balancer = false
  
  # Enforces highly secure, modernized encryption standards out of the box
  ssl_policy = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}
