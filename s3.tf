resource "aws_s3_bucket" "private" {
  # bucket name
  bucket = "private-progmatic-terraform-on-aws-hirokihello"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket" "public" {
  # bucket name
  bucket = "public-progmatic-terraform-on-aws-hirokihello"
  acl = "public-read"
  versioning {
    enabled = true
  }

  cors_rule {
    allowed_origins = ["https://example.com"]
    allowed_methods = ["GET"]
    allowed_headers = ["*"]
    max_age_seconds = 3000
  }
}
#
resource "aws_s3_bucket_public_access_block" "private" {
  bucket = aws_s3_bucket.private.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

# log bucket
resource "aws_s3_bucket" "alb_log" {
  bucket = "alb-log-progmatic-terraform-on-aws-hirokihello"

  lifecycle_rule {
    enabled = true

    expiration {
      days = "180"
    }
  }
}

# bucket policy definition
resource "aws_s3_bucket_policy" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id
  policy = data.aws_iam_policy_document.alb_log.json
}

data "aws_iam_policy_document" "alb_log" {
  statement {
    effect = "Allow"
    actions = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.alb_log.id}/*"]

    principals {
      type = "AWS"
      identifiers = ["582318560864"]
    }
  }
}