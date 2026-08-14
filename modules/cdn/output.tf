output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.cdn.domain_name
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.static_bucket.arn
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.cdn.id
}