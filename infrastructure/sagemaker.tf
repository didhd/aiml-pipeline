resource "aws_sagemaker_domain" "this" {
  domain_name = "${var.project_name}-domain"
  auth_mode   = "IAM"
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.private_subnets

  default_user_settings {
    execution_role  = aws_iam_role.sagemaker_role.arn
    security_groups = [aws_security_group.sagemaker.id]
  }

  app_network_access_type = "VpcOnly"

  tags = var.tags
}

resource "aws_security_group" "sagemaker" {
  name_prefix = "${var.project_name}-sagemaker-sg"
  description = "Security group for SageMaker Domain"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "NFS traffic for EFS"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    self        = true
  }

  ingress {
    description = "Jupyter Server to Kernel Gateway traffic"
    from_port   = 8192
    to_port     = 65535
    protocol    = "tcp"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-sagemaker-sg"
  })
}

resource "aws_sagemaker_user_profile" "this" {
  domain_id         = aws_sagemaker_domain.this.id
  user_profile_name = var.sagemaker_user_profile_name

  user_settings {
    execution_role  = aws_iam_role.sagemaker_role.arn
    security_groups = [aws_security_group.sagemaker_user.id]
  }

  tags = var.tags
}

resource "aws_security_group" "sagemaker_user" {
  name_prefix = "${var.project_name}-sagemaker-user-sg"
  description = "Security group for SageMaker User Profile"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Self referencing rule"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-sagemaker-user-sg"
  })
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

resource "aws_iam_role_policy_attachment" "redshift_full_access" {
  role       = aws_iam_role.sagemaker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRedshiftFullAccess"
}
