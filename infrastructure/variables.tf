# infrastructure/variables.tf

variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "ap-northeast-2"
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "stoa-aiml-pipeline"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "redshift_database_name" {
  description = "The name of the first database to be created in the Redshift Serverless namespace"
  type        = string
  default     = "dev"
}

variable "redshift_admin_username" {
  description = "Username for the Redshift Serverless admin user"
  type        = string
  default     = "admin"
}

variable "redshift_admin_password" {
  description = "Password for the Redshift Serverless admin user"
  type        = string
  sensitive   = true
}

variable "sagemaker_user_profile_name" {
  description = "The name of the SageMaker user profile"
  type        = string
  default     = "default-user"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "aiml-pipeline"
  }
}
