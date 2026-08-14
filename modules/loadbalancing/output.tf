output "alb_dns_name" {
  value = aws_lb.web_alb.dns_name
}

output "alb_security_group_id" {
  value = aws_security_group.alb_sg.id
}

output "target_group_arn" {
  value = aws_lb_target_group.web_tg.arn
}

output "alb_arn" {
  value = aws_lb.web_alb.arn
}

# ===== THÊM MỚI =====
output "cloudfront_certificate_arn" {
  value = aws_acm_certificate_validation.cloudfront_cert_validation.certificate_arn
}