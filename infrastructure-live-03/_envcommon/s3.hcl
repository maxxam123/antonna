# Define the source of the official AWS S3 registry module
terraform {
  source = "tfr:///terraform-aws-modules/s3-bucket/aws?version=4.2.0"
}

# Define base inputs that every environment shares by default
inputs = {
  bucket        = "company-generic-app-data"
  acl           = "private"
  force_destroy = false

  # Enable versioning for data safety
  versioning = {
    enabled = true
  }

  # Enforce strict security settings by blocking all public access
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  tags = {
    Terraform   = "true"
    ManagedBy   = "Terragrunt"
    Component   = "Storage"
  }
}
