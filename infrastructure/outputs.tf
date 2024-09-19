# infrastructure/outputs.tf

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket"
  value       = module.s3_bucket.s3_bucket_id
}

output "redshift_serverless_namespace" {
  description = "The name of the Redshift Serverless namespace"
  value       = aws_redshiftserverless_namespace.this.namespace_name
}

output "redshift_serverless_workgroup" {
  description = "The name of the Redshift Serverless workgroup"
  value       = aws_redshiftserverless_workgroup.this.workgroup_name
}

output "sagemaker_domain_id" {
  description = "The ID of the SageMaker Domain"
  value       = aws_sagemaker_domain.this.id
}

output "sagemaker_user_profile_name" {
  description = "The name of the SageMaker User Profile"
  value       = aws_sagemaker_user_profile.this.user_profile_name
}
