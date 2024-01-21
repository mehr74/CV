output "aws_s3_bucket" {
  value = aws_s3_bucket.bucket.bucket
}

output "aws_iam_role" {
  value = aws_iam_role.bucket_role.arn
}