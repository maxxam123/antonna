# infrastructure-modules/vpc-routing/variables.tf

variable "vpc_id" {
  type        = string
  description = "The target AWS Virtual Private Cloud ID."
}

variable "prefix" {
  type        = string
  description = "Corporate standardized organizational prefix (e.g., 'corp-it')."
}

variable "environment" {
  type        = string
  description = "Deployment lifecycle stage (e.g., dev, staging, prod)."
}

variable "availability_zones" {
  type        = set(string)
  description = "Set of targeted AWS availability zones (e.g., ['eu-central-1a', 'eu-central-1b'])."
}

variable "corporate_supernet_cidr" {
  type        = string
  default     = "192.168.0.0/16"
  description = "The consolidated CIDR range encompassing on-prem data centers and cross-region VPC infrastructure."
}

variable "secure_target_cidr" {
  type        = string
  description = "The specific isolated network range requiring explicit ENI-targeted routing."
}

variable "tgw_id" {
  type        = string
  description = "The core Core Transit Gateway ID."
}

variable "fw_endpoints_by_az" {
  type        = map(string)
  description = "Map of AWS Network Firewall VPC Endpoint IDs corresponding to each availability zone key."
}

variable "vpc_endpoint_eni_ids_by_az" {
  type        = map(string)
  description = "Map of specific Elastic Network Interface IDs for isolated endpoint paths sorted by AZ."
}

variable "private_subnet_ids_by_az" {
  type        = map(string)
  description = "Map containing the target subnet IDs where these route tables must be bound."
}

variable "global_tags" {
  type        = map(string)
  description = "Mandatory enterprise metadata tags (CostCenter, DataClassification, Owner)."
}
