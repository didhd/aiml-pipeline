# infrastructure/main.tf

provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0" # 최신 버전으로 업데이트

  name = "${var.project_name}-vpc"
  cidr = var.vpc_cidr

  azs             = slice(data.aws_availability_zones.available.names, 0, 3)
  private_subnets = [for i in range(3) : cidrsubnet(var.vpc_cidr, 4, i)]
  public_subnets  = [for i in range(3) : cidrsubnet(var.vpc_cidr, 4, i + 3)]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = var.tags
}

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.0"

  bucket = "${var.project_name}-bucket"

  versioning = {
    enabled = true
  }

  tags = var.tags
}

resource "aws_redshiftserverless_namespace" "this" {
  namespace_name      = "${var.project_name}-namespace"
  admin_username      = var.redshift_admin_username
  admin_user_password = var.redshift_admin_password
  db_name             = var.redshift_database_name

  tags = var.tags
}

resource "aws_redshiftserverless_workgroup" "this" {
  namespace_name = aws_redshiftserverless_namespace.this.namespace_name
  workgroup_name = "${var.project_name}-workgroup"

  enhanced_vpc_routing = true

  security_group_ids = [module.vpc.default_security_group_id]
  subnet_ids         = module.vpc.private_subnets

  tags = var.tags
}

resource "aws_sagemaker_domain" "this" {
  domain_name = "${var.project_name}-domain"
  auth_mode   = "IAM"
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.private_subnets

  default_user_settings {
    execution_role = aws_iam_role.sagemaker_role.arn
  }

  tags = var.tags
}

resource "aws_sagemaker_user_profile" "this" {
  domain_id         = aws_sagemaker_domain.this.id
  user_profile_name = var.sagemaker_user_profile_name

  user_settings {
    execution_role = aws_iam_role.sagemaker_role.arn
  }

  tags = var.tags
}

resource "aws_iam_role" "sagemaker_role" {
  name = "${var.project_name}-sagemaker-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "sagemaker.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "sagemaker_full_access" {
  role       = aws_iam_role.sagemaker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}
