variable "domain_name" {
  description = "Domain name for the website"
  type        = string
}

variable "route53_zone_id" {
  description = "Route53 hosted zone ID"
  type        = string
}

variable "s3_bucket_name" {
  description = "Name of S3 bucket for static content"
  type        = string
}

variable "alb_dns_name" {
  description = "DNS name of the ALB (origin for API)"
  type        = string
}

# ===== THÊM MỚI =====
variable "cloudfront_certificate_arn" {
  description = "ACM certificate ARN for CloudFront (must be in us-east-1)"
  type        = string
}