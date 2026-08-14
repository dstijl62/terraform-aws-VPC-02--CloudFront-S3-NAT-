# Certificate cho ALB (ở region chính)
resource "aws_acm_certificate" "alb_cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"
  tags = {
    Name = "ALB-Certificate"
  }
}

# Record validation
resource "aws_route53_record" "alb_cert_validation" {
  zone_id = var.route53_zone_id
  name    = tolist(aws_acm_certificate.alb_cert.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.alb_cert.domain_validation_options)[0].resource_record_type
  records = [tolist(aws_acm_certificate.alb_cert.domain_validation_options)[0].resource_record_value]
  ttl     = 60
}

# Certificate validation
resource "aws_acm_certificate_validation" "alb_cert_validation" {
  certificate_arn         = aws_acm_certificate.alb_cert.arn
  validation_record_fqdns = [aws_route53_record.alb_cert_validation.fqdn]
}

# Listener HTTP (redirect sang HTTPS)
resource "aws_lb_listener" "web_listener_http" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# Listener HTTPS
resource "aws_lb_listener" "web_listener_https" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2021-06"
  certificate_arn   = aws_acm_certificate_validation.alb_cert_validation.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}