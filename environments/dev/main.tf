terraform {
  required_version = ">= 1.0"
}

module "networking" {
  source = "../../modules/networking"

  vpc_cidr_block = var.vpc_cidr_block
  vpc_name       = var.vpc_name

  public_subnet1_cidr_block = var.public_subnet1_cidr_block
  public_subnet1_az         = var.public_subnet1_az
  public_subnet1_name       = var.public_subnet1_name

  public_subnet2_cidr_block = var.public_subnet2_cidr_block
  public_subnet2_az         = var.public_subnet2_az
  public_subnet2_name       = var.public_subnet2_name

  private_subnet1_cidr_block = var.private_subnet1_cidr_block
  private_subnet1_az         = var.private_subnet1_az
  private_subnet1_name       = var.private_subnet1_name

  private_subnet2_cidr_block = var.private_subnet2_cidr_block
  private_subnet2_az         = var.private_subnet2_az
  private_subnet2_name       = var.private_subnet2_name
}

module "iam" {
  source = "../../modules/iam"
}

module "loadbalancing" {
  source = "../../modules/loadbalancing"

  providers = {
    aws.us_east_1 = aws.us_east_1
  }

  vpc_id            = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids
  domain_name       = var.domain_name
  route53_zone_id   = var.route53_zone_id
}

module "compute" {
  source = "../../modules/compute"

  vpc_id                = module.networking.vpc_id
  subnet_ids            = module.networking.private_subnet_ids # EC2 in private subnets
  alb_security_group_id = module.loadbalancing.alb_security_group_id
  ssh_allowed_cidr      = var.ssh_allowed_cidr
  ami_id                = var.ami_id
  key_name              = var.key_name
  instance_type         = var.instance_type
  instance_profile_name = module.iam.instance_profile_name
  target_group_arn      = module.loadbalancing.target_group_arn
  desired_capacity      = var.desired_capacity
  min_size              = var.min_size
  max_size              = var.max_size
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

  # ===== XÓA block providers (không cần) =====

  domain_name     = var.domain_name
  route53_zone_id = var.route53_zone_id
  s3_bucket_name  = var.s3_bucket_name
  alb_dns_name    = module.loadbalancing.alb_dns_name

  # ===== THÊM DÒNG NÀY =====
  cloudfront_certificate_arn = module.loadbalancing.cloudfront_certificate_arn
}