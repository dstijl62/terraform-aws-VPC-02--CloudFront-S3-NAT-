# Security Group for ALB
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}

# Target Group
resource "aws_lb_target_group" "web_tg" {
  name        = "web-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    protocol            = "HTTP"
    path                = "/"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 15
    matcher             = "200-399"
  }

  deregistration_delay = 60
  tags = {
    Name = "web-tg"
  }
}

# ALB
resource "aws_lb" "web_alb" {
  name               = "web-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnet_ids

  tags = {
    Name = "web-alb"
  }
}

# Certificate for ALB (ap-northeast-1)
resource "aws_acm_certificate" "alb_cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"
  tags = {
    Name = "ALB-Certificate"
  }
}

# Route53 validation record for ALB certificate
resource "aws_route53_record" "alb_cert_validation" {
  zone_id = var.route53_zone_id
  name    = tolist(aws_acm_certificate.alb_cert.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.alb_cert.domain_validation_options)[0].resource_record_type
  records = [tolist(aws_acm_certificate.alb_cert.domain_validation_options)[0].resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "alb_cert_validation" {
  certificate_arn         = aws_acm_certificate.alb_cert.arn
  validation_record_fqdns = [aws_route53_record.alb_cert_validation.fqdn]
}

# HTTP Listener (redirect to HTTPS)
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

# HTTPS Listener
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

# ===== THÊM MỚI: Certificate cho CloudFront (us-east-1) =====
resource "aws_acm_certificate" "cloudfront_cert" {
  provider          = aws.us_east_1
  domain_name       = var.domain_name
  validation_method = "DNS"
  tags = {
    Name = "CloudFrontCertificate"
  }
}

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