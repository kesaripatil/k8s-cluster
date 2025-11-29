resource "aws_s3_bucket" "tfstate" {
  bucket = var.manual-k8s-tfstate-bucket-name
  force_destroy = true

  tags = {
    Name        = var.manual-k8s-tfstate-bucket-name
    Description = "Stores Terraform state for Kubernetes infra"
    Project     = var.project_name
  }
}

resource "aws_s3_bucket_versioning" "tfstate_versioning" {
  bucket = aws_s3_bucket.tfstate.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate_encryption" {
  bucket = aws_s3_bucket.tfstate.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
