terraform {
  backend "s3" {
    bucket = "terraform-k8s-tfstate-bucket"
    key = "k8s-cluster-setup/terraform.tfstate"
    region = "ap-south-1"
    encrypt = true
    # dynamodb_table = "terraform-locks"
  }
}
