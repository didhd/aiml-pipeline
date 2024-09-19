# vpc_endpoints.tf

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = module.vpc.private_route_table_ids

  tags = merge(var.tags, {
    Name = "${var.project_name}-s3-endpoint"
  })
}

resource "aws_vpc_endpoint" "sagemaker_api" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.sagemaker.api"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc.private_subnets
  security_group_ids  = [aws_security_group.sagemaker.id]
  private_dns_enabled = true

  tags = merge(var.tags, {
    Name = "${var.project_name}-sagemaker-api-endpoint"
  })
}

resource "aws_vpc_endpoint" "sagemaker_runtime" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.sagemaker.runtime"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc.private_subnets
  security_group_ids  = [aws_security_group.sagemaker.id]
  private_dns_enabled = true

  tags = merge(var.tags, {
    Name = "${var.project_name}-sagemaker-runtime-endpoint"
  })
}

resource "aws_vpc_endpoint" "sts" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.sts"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc.private_subnets
  security_group_ids  = [aws_security_group.sagemaker.id]
  private_dns_enabled = true

  tags = merge(var.tags, {
    Name = "${var.project_name}-sts-endpoint"
  })
}

resource "aws_vpc_endpoint" "cloudwatch" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.logs"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc.private_subnets
  security_group_ids  = [aws_security_group.sagemaker.id]
  private_dns_enabled = true

  tags = merge(var.tags, {
    Name = "${var.project_name}-cloudwatch-endpoint"
  })
}

resource "aws_vpc_endpoint" "servicecatalog" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.servicecatalog"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc.private_subnets
  security_group_ids  = [aws_security_group.sagemaker.id]
  private_dns_enabled = true

  tags = merge(var.tags, {
    Name = "${var.project_name}-servicecatalog-endpoint"
  })
}

resource "aws_vpc_endpoint" "redshift" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.redshift"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc.private_subnets
  security_group_ids  = [aws_security_group.sagemaker.id, aws_security_group.redshift.id]
  private_dns_enabled = true

  tags = merge(var.tags, {
    Name = "${var.project_name}-redshift-endpoint"
  })
}
