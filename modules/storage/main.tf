# S3 Buckets

# General Purpose Bucket
resource "aws_s3_bucket" "general_bucket" {
  bucket = "${var.project}-${var.environment}-general"

  tags = {
    "Environment" = var.environment
    "Project"     = var.project
  }
}

resource "aws_s3_bucket_ownership_controls" "general_bucket" {
  bucket = aws_s3_bucket.general_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "general_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.example]

  bucket = aws_s3_bucket.general_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.general_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.general_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

# Additional buckets as needed (e.g., for logs, backups)
