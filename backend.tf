# Create s3 bucket for terraform state file
resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket_name # Change to a unique bucket name
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = var.bucket_name
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket-encrypt" {
  bucket = var.bucket_name

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Create DynamoDB table for terraform state locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.dynamodb_name 
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}