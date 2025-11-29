resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name        = "${var.project_name}-vpc"
    Description = "Main VPC for Kubernetes cluster"
    Project     = var.project_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name        = "${var.project_name}-igw"
    Description = "Internet Gateway for public subnet"
    Project     = var.project_name
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}a"
  tags = {
    Name        = "${var.project_name}-public-subnet"
    Description = "Public subnet for master node and NAT"
    Project     = var.project_name
    "kubernetes.io/role/elb"         = "1"
    "kubernetes.io/cluster/kube-handson" = "owned"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_b_cidr
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}b"
  tags = {
    Name        = "${var.project_name}-public-subnet_b"
    Description = "Public subnet for master node and NAT"
    Project     = var.project_name
    "kubernetes.io/role/elb"         = "1"
    "kubernetes.io/cluster/kube-handson" = "owned"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "${var.region}a"
  tags = {
    Name        = "${var.project_name}-private-subnet"
    Description = "Private subnet for worker nodes"
    Project     = var.project_name
  }
}

