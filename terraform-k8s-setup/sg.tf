# Security Group for Kubernetes Control Plane
resource "aws_security_group" "controlplane_sg" {
  name        = "${var.project_name}-controlplane-sg"
  description = "Allow Kubernetes control plane traffic"
  vpc_id      = aws_vpc.main.id

  # --- Inbound rules ---

  # Allow workers to reach API server
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]   # restrict to VPC only
  }

  # Allow kubelet API (control plane components -> kubelet)
  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  # Allow etcd client/peer (control plane only)
  ingress {
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  # Optional: controller-manager and scheduler ports
  ingress {
    from_port   = 10257
    to_port     = 10257
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    from_port   = 10259
    to_port     = 10259
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  # Allow BGP (Calico)
  ingress {
    from_port   = 179
    to_port     = 179
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  # --- Outbound rules ---
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project = var.project_name
    Role    = "controlplane"
  }
}

# Security Group for Worker Nodes
resource "aws_security_group" "worker_sg" {
  name        = "${var.project_name}-worker-sg"
  description = "Worker node SG for Kubernetes cluster"
  vpc_id      = aws_vpc.main.id

  # Allow API server to talk to kubelet
  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]   # restrict to VPC
  }

  # Allow kube-proxy metrics
  ingress {
    from_port   = 10256
    to_port     = 10256
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  # Allow NodePort range (for services/Ingress)
  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]  # only ALB can reach
  }

  # Allow overlay networking (Calico/Flannel)
  ingress {
    from_port   = 4789
    to_port     = 4789
    protocol    = "udp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    from_port   = 8472
    to_port     = 8472
    protocol    = "udp"
    cidr_blocks = [var.vpc_cidr]
  }

  # Allow BGP (Calico)
  ingress {
    from_port   = 179
    to_port     = 179
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project = var.project_name
    Role = "Worker Node"
  }
}

