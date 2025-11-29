resource "aws_instance" "master" {
  ami                         = var.ami_id
  instance_type               = var.master_instance_type
  subnet_id                   = aws_subnet.private.id
  iam_instance_profile        = aws_iam_instance_profile.ssm_profile.name
  user_data                   = file("${path.module}/scripts/master-init.sh")
  root_block_device {
    volume_size = 30
    volume_type = "gp3"
    delete_on_termination = true
  }

  depends_on = [
    aws_nat_gateway.nat,
    aws_route_table_association.private_assoc,
    aws_vpc_endpoint.ssm,
    aws_vpc_endpoint.ssmmessages,
    aws_vpc_endpoint.ec2messages
  ]
  vpc_security_group_ids = [aws_security_group.controlplane_sg.id]

  tags = {
    Name        = "${var.project_name}-master-node"
    Description = "Kubernetes master node"
    Role        = "Master"
    Project     = var.project_name
  }
}

resource "aws_instance" "worker" {
  count                = var.worker_count
  ami                  = var.ami_id
  instance_type        = var.worker_instance_type
  subnet_id            = aws_subnet.private.id
  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name
  user_data            = file("${path.module}/scripts/worker-init.sh")
  root_block_device {
    volume_size = 30
    volume_type = "gp3"
    delete_on_termination = true
  }

  depends_on = [
    aws_nat_gateway.nat,
    aws_route_table_association.private_assoc,
    aws_vpc_endpoint.ssm,
    aws_vpc_endpoint.ssmmessages,
    aws_vpc_endpoint.ec2messages
  ]

  vpc_security_group_ids = [aws_security_group.worker_sg.id]

  tags = {
    Name        = "${var.project_name}-worker-node"
    Description = "Kubernetes worker node"
    Role        = "Worker"
    Project     = var.project_name
  }
}

