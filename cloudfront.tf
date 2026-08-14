# S3 Origin Access Identity (đã có trong s3.tf, dùng lại)
# Nếu chưa có, thêm resource:
# resource "aws_cloudfront_origin_access_identity" "oai" {
#   comment = "OAI for S3 static content"
# }

resource "aws_cloudfront_distribution" "cdn" {
  enabled             = true
  default_root_object = "index.html"

  # ===== ORIGIN 1: S3 (static ReactJS) =====
  origin {
    domain_name = aws_s3_bucket.static_bucket.bucket_regional_domain_name
    origin_id   = "s3-static-origin"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  # ===== ORIGIN 2: ALB (backend API NodeJS) =====
  origin {
    domain_name = aws_lb.web_alb.dns_name
    origin_id   = "alb-api-origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only" # ALB đã có listener HTTPS
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  # ===== DEFAULT CACHE BEHAVIOR: phục vụ static từ S3 =====
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3-static-origin"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 86400    # 1 ngày
    max_ttl                = 31536000 # 1 năm
    compress               = true
  }

  # ===== CACHE BEHAVIOR CHO API (path /api/*) =====
  ordered_cache_behavior {
    path_pattern     = "/api/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "alb-api-origin"

    forwarded_values {
      query_string = true
      headers      = ["Authorization", "Origin", "Access-Control-Request-Method", "Access-Control-Request-Headers"]
      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
    compress               = false
  }

  # ===== CERTIFICATE (giữ nguyên) =====
  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.cloudfront_cert_validation.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  # ===== RESTRICTIONS =====
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name = "CloudFrontDistribution"
  }
}