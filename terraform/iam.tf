resource "aws_iam_policy" "bucket_policy" {
  name        = "${var.bucket_name}-policy"
  description = "Policy to allow pushing files to S3"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListBucket",
        ],

        Resource = [
          aws_s3_bucket.bucket.arn,
          "${aws_s3_bucket.bucket.arn}/*",
        ]
      },
    ]
  })
}

resource "aws_iam_role" "bucket_role" {
  name = "${var.bucket_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity",
        Effect = "Allow",
        Principal = {
          Federated = "var.github_oidc_provider_arn"
        },
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "${var.bucket_name}",
            "token.actions.githubusercontent.com:sub" = ["repo:${var.github_owner}/${var.github_repo}:ref:refs/heads/main"]
          }
        }
      }
    ]
  })
}

# attach s3 bucket policy to s3 bucket role
resource "aws_iam_role_policy_attachment" "bucket_policy_attachment" {
  role       = aws_iam_role.bucket_role.name
  policy_arn = aws_iam_policy.bucket_policy.arn
}