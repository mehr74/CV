resource "aws_s3_bucket" "bucket" {
  bucket = "mehrshad-cv"

  tags = var.tags
}