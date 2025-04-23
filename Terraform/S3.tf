Terraform script to create 3 S3 buckets with specific configuration using terraform-aws-s3-bucket module v3.1.0

terraform { required_providers { aws = { source  = "hashicorp/aws" version = "~> 5.0" } }

required_version = ">= 1.0.0" }

provider "aws" { region = "us-east-1" }

module "s3_upload_bucket" { source  = "terraform-aws-modules/s3-bucket/aws" version = "3.1.0"

bucket = "cmm-upload-bucket"

acl    = "private"

versioning = { enabled = true }

server_side_encryption_configuration = { rule = { apply_server_side_encryption_by_default = { sse_algorithm = "AES256" } } }

lifecycle_rule = [ { id      = "archive-then-delete" enabled = true

transition = [{
    days          = 60
    storage_class = "GLACIER"
  }]

  expiration = {
    days = 90
  }
}

]

attach_policy = true policy = jsonencode({ Version = "2012-10-17", Statement = [ { Effect   = "Allow", Action   = ["s3:PutObject"], Resource = ["arn:aws:s3:::cmm-upload-bucket/*"], Principal = { AWS = "arn:aws:iam::YOUR_ACCOUNT_ID:role/YOUR_UPLOAD_ROLE" } } ] }) }

module "s3_download_bucket" { source  = "terraform-aws-modules/s3-bucket/aws" version = "3.1.0"

bucket = "cmm-download-bucket" acl    = "private"

versioning = { enabled = true }

server_side_encryption_configuration = { rule = { apply_server_side_encryption_by_default = { sse_algorithm = "AES256" } } }

lifecycle_rule = [ { id      = "archive-then-delete" enabled = true transition = [{ days          = 60 storage_class = "GLACIER" }] expiration = { days = 90 } } ]

attach_policy = true policy = jsonencode({ Version = "2012-10-17", Statement = [ { Effect   = "Allow", Action   = ["s3:GetObject"], Resource = ["arn:aws:s3:::cmm-download-bucket/*"], Principal = { AWS = "arn:aws:iam::YOUR_ACCOUNT_ID:role/YOUR_DOWNLOAD_ROLE" } } ] }) }

module "s3_app_data_bucket" { source  = "terraform-aws-modules/s3-bucket/aws" version = "3.1.0"

bucket = "cmm-app-data-bucket" acl    = "private"

versioning = { enabled = true }

server_side_encryption_configuration = { rule = { apply_server_side_encryption_by_default = { sse_algorithm = "AES256" } } }

lifecycle_rule = [ { id      = "archive-then-delete" enabled = true transition = [{ days          = 60 storage_class = "GLACIER" }] expiration = { days = 90 } } ]

attach_policy = false }

