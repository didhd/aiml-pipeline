resource "aws_redshiftserverless_namespace" "this" {
  namespace_name      = "${var.project_name}-namespace"
  admin_username      = var.redshift_admin_username
  admin_user_password = var.redshift_admin_password
  db_name             = var.redshift_database_name

  tags = var.tags
}

resource "aws_security_group" "redshift" {
  name        = "${var.project_name}-redshift-sg"
  description = "Security group for Redshift Serverless workgroup"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "Allow inbound traffic from SageMaker to Redshift"
    from_port       = 5439
    to_port         = 5439
    protocol        = "tcp"
    security_groups = [aws_security_group.sagemaker.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-redshift-sg"
  })
}

resource "aws_redshiftserverless_workgroup" "this" {
  namespace_name = aws_redshiftserverless_namespace.this.namespace_name
  workgroup_name = "${var.project_name}-workgroup"

  enhanced_vpc_routing = true

  security_group_ids = [aws_security_group.redshift.id]
  subnet_ids         = module.vpc.private_subnets

  tags = var.tags
}
