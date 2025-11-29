variable "region" {
  default = "ap-south-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  default = "10.0.2.0/24"
}

variable "public_subnet_b_cidr" {
  default = "10.0.3.0/24"
}

variable "ami_id" {
  default = "ami-0088a4dc01f0b276f" # Ubuntu 22.04 LTS (Mumbai)
}

variable "master_instance_type" {
  default = "t3.medium"
}

variable "worker_instance_type" {
  default = "t3.medium"
}

variable "worker_count" {
  default = 1
}

variable "project_name" {
  default = "manual-k8s"
}
