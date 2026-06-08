resource "aws_s3_bucket" "main" {
  bucket = "${var.project_name}-storage-bucket"

  tags = {
    Name        = "${var.project_name}-bucket"
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}