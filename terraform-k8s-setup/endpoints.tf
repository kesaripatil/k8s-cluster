resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.ssm"
  subnet_ids        = [aws_subnet.private.id]
  vpc_endpoint_type = "Interface"
  tags = {
    Name        = "${var.project_name}-ssm-endpoint"
    Description = "VPC endpoint for SSM"
    Project     = var.project_name
  }
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.ssmmessages"
  subnet_ids        = [aws_subnet.private.id]
  vpc_endpoint_type = "Interface"
  tags = {
    Name        = "${var.project_name}-ssmmessages-endpoint"
    Description = "VPC endpoint for SSM messages"
    Project     = var.project_name
  }
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.ec2messages"
  subnet_ids        = [aws_subnet.private.id]
  vpc_endpoint_type = "Interface"
  tags = {
    Name        = "${var.project_name}-ec2messages-endpoint"
    Description = "VPC endpoint for EC2 messages"
    Project     = var.project_name
  }
}

