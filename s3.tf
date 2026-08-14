resource "aws_s3_bucket" "static_bucket" {
  bucket        = var.s3_bucket_name
  force_destroy = true

  tags = {
    Name = "StaticBucket"
  }
}

resource "aws_s3_bucket_public_access_block" "static_bucket_block" {
  bucket = aws_s3_bucket.static_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "static_bucket_versioning" {
  bucket = aws_s3_bucket.static_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}


# Tạo Origin Access Identity cho CloudFront
resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for CloudFront to access S3 bucket"
}

# Sửa bucket policy để cho phép CloudFront (qua OAI) đọc bucket
resource "aws_s3_bucket_policy" "static_bucket_policy" {
  bucket = aws_s3_bucket.static_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.oai.id}"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.static_bucket.arn}/*"
      }
    ]
  })
}

# Nếu bạn dùng S3 làm origin thay vì ALB, hãy sửa origin trong cloudfront.tf