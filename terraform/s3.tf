resource "aws_s3_bucket" "bucket" {
  bucket = "${var.name}-bucket"

  tags = var.tags
}