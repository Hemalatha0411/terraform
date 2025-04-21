resource "random_id" "random_hex" {
  byte_length = 8
}
resource "aws_s3_bucket" "cmm-poc-bucket" {
  bucket = format("%s-%s", var.bucket_name, random_id.random_hex.hex)# Change to a globally unique name

  tags = {
    Name        = "cmm-poc-dev"
    Environment = "Dev"
    Terraform   = "true"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.cmm-poc-bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.cmm-poc-bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  bucket = aws_s3_bucket.cmm-poc-bucket.id

  rule {
    id     = "ArchiveAndDelete"
    status = "Enabled"
    filter {
      prefix = "config/"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }

    expiration {
      days = 90
    }

    noncurrent_version_transition {
      noncurrent_days = 60
      storage_class = "GLACIER"
    }

    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }
}

