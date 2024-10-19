variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "The AWS CLI profile to use"
  type        = string
  default     = "default"
}

# Additional variables for tagging, environment, etc.
variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
  default     = "prod"
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "acme-brick"
}

variable "db_password" {
  description = "The password for the database"
  type        = string
}

variable "github_repo" {
  description = "The GitHub repository to use for the CodePipeline"
  type        = string
  
}
