
# output "instance_ami" {
#   value = aws_instance.web.ami
# }

# output "instance_state" {
#   value = aws_instance.web.instance_state
#   description = "Trang thai hien tai cua VM WEB"
# }

# output "public_ip" {
#   value = aws_instance.web.public_ip
#   sensitive = true
# }


output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.web_alb.dns_name
}

output "cloudfront_domain_name" {
  description = "The domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.cdn.domain_name
}

output "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = aws_db_instance.rds.endpoint
  sensitive   = true
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.static_bucket.arn
}