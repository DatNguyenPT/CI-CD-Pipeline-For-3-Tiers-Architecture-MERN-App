module "s3_backend" {
  source  = "terraform-aws-modules/s3-bucket/aws"

  bucket        = "datnguyen-s3-backend-bucket"
  force_destroy = false

  control_object_ownership = true
  object_ownership         = "BucketOwnerPreferred"

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  acl = "public-read"

  attach_policy = true
  policy        = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "arn:aws:s3:::datnguyen-s3-backend-bucket/*"
      },
    ]
  })

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name        = "datnguyen-s3-backend"
    Environment = "Production"
  }
}
