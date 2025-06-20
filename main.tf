resource "aws_s3_bucket" "example" {
  bucket = var.test_bucket_name

  tags = {
    Name        = var.s3_bucket_tag
    Environment = var.environment
  }
}