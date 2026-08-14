terraform {
  required_version = ">= 1.0"
}

# ===== THÊM 2 PROVIDER BLOCK NÀY =====
provider "aws" {
  region = "ap-northeast-1"
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

# ===== ACM Certificate for CloudFront (must be in us-east-1) =====
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

# ===== Modules =====
module "networking" {
  source = "../../modules/networking"

  vpc_cidr_block = var.vpc_cidr_block
  vpc_name       = var.vpc_name
  # ... các biến khác
}

module "iam" {
  source = "../../modules/iam"
}

module "loadbalancing" {
  source = "../../modules/loadbalancing"
  # KHÔNG CÓ providers block

  vpc_id            = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids
  domain_name       = var.domain_name
  route53_zone_id   = var.route53_zone_id
}

module "compute" {
  source = "../../modules/compute"

  vpc_id                 = module.networking.vpc_id
  subnet_ids             = module.networking.private_subnet_ids
  alb_security_group_id  = module.loadbalancing.alb_security_group_id
  ssh_allowed_cidr       = var.ssh_allowed_cidr
  ami_id                 = var.ami_id
  key_name               = var.key_name
  instance_type          = var.instance_type
  instance_profile_name  = module.iam.instance_profile_name
  target_group_arn       = module.loadbalancing.target_group_arn
  desired_capacity       = var.desired_capacity
  min_size               = var.min_size
  max_size               = var.max_size
}

module "database" {
  source = "../../modules/database"

  vpc_id                = module.networking.vpc_id
  private_subnet_ids    = module.networking.private_subnet_ids
  web_security_group_id = module.compute.web_security_group_id
  db_identifier         = var.db_identifier
  db_engine             = var.db_engine
  db_engine_version     = var.db_engine_version
  db_instance_class     = var.db_instance_class
  allocated_storage     = var.allocated_storage
  storage_type          = var.storage_type
  db_username           = var.db_username
  db_password           = var.db_password
  multi_az              = var.multi_az
}

module "cdn" {
  source = "../../modules/cdn"

  domain_name     = var.domain_name
  route53_zone_id = var.route53_zone_id
  s3_bucket_name  = var.s3_bucket_name
  alb_dns_name    = module.loadbalancing.alb_dns_name
  # === QUAN TRỌNG: Truyền ARN certificate từ resource root ===
  cloudfront_certificate_arn = aws_acm_certificate_validation.cloudfront_cert_validation.certificate_arn
}