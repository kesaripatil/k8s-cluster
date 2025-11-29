terraform {
  backend "s3" {
    bucket = "terraform-k8s-tfstate-bucket"
    key = "state-backend/terraform.tfstate"
    encrypt = true
    region = "ap-south-1"
  }
}
