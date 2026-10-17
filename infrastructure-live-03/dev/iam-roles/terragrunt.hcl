# infrastructure-live-03/dev/identity-access/iam-roles/terragrunt.hcl

include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/iam_roles.hcl"
  expose = true
}

inputs = {
  environment = "dev"

  # Define your corporate identity landscape layout
  iam_roles_config = {
    
    # Target 1: EC2 Secure Bastion/Jump Box Role
    bastion_host = {
      description             = "Execution permissions for core engineering access bastion nodes"
      trusted_service         = "://amazonaws.com"
      create_instance_profile = true
      managed_policy_arns = {
        ssm_core       = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
        cloudwatch_ops = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
      }
    }

    # Target 2: ECS Container Application Task Execution Role
    app_ecs_execution = {
      description             = "System tasks orchestration permissions for microservices containers"
      trusted_service         = "://amazonaws.com"
      create_instance_profile = false
      managed_policy_arns = {
        ecs_execution = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
        xray_daemon   = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
      }
    }

    # Target 3: Serverless Backend Lambda Worker Role
    data_processor_lambda = {
      description             = "Compute context execution rights for payment pipeline routines"
      trusted_service         = "://amazonaws.com"
      create_instance_profile = false
      managed_policy_arns = {
        lambda_basic = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
        vpc_access   = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
      }
    }
  }

  global_tags = merge(
    include.root.inputs.global_tags,
    {
      Environment       = "dev"
      SecurityBoundary  = "Identity-Access-Management"
      CostCenter        = "FIN-IDENTITY-0012"
    }
  )
}
