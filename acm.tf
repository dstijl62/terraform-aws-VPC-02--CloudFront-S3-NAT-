provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

resource "aws_acm_certificate" "cloudfront_cert" {
  provider          = aws.us_east_1
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = {
    Name = "CloudFrontCertificate"
  }
}

resource "aws_route53_record" "cert_validation" {
  zone_id = var.route53_zone_id

  # dùng tolist để lấy phần tử đầu tiên của set
  name    = tolist(aws_acm_certificate.cloudfront_cert.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.cloudfront_cert.domain_validation_options)[0].resource_record_type
  records = [tolist(aws_acm_certificate.cloudfront_cert.domain_validation_options)[0].resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cloudfront_cert_validation" {
  provider = aws.us_east_1

  certificate_arn         = aws_acm_certificate.cloudfront_cert.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}