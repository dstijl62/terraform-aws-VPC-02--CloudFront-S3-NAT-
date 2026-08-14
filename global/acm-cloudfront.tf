# ACM Certificate cho CloudFront (bắt buộc ở us-east-1)
resource "aws_acm_certificate" "cloudfront_cert" {
  provider          = aws.us_east_1
  domain_name       = var.domain_name
  validation_method = "DNS"
  tags = {
    Name = "CloudFrontCertificate"
  }
}

# Route53 validation record
resource "aws_route53_record" "cloudfront_cert_validation" {
  zone_id = var.route53_zone_id
  name    = tolist(aws_acm_certificate.cloudfront_cert.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.cloudfront_cert.domain_validation_options)[0].resource_record_type
  records = [tolist(aws_acm_certificate.cloudfront_cert.domain_validation_options)[0].resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cloudfront_cert_validation" {
  provider          = aws.us_east_1
  certificate_arn   = aws_acm_certificate.cloudfront_cert.arn
  validation_record_fqdns = [aws_route53_record.cloudfront_cert_validation.fqdn]
}