variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "192.168.0.0/16"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "Main-VPC"
}

variable "public_subnet1_cidr_block" {
  description = "CIDR block for the first public subnet"
  type        = string
  default     = "192.168.1.0/24"
}

variable "public_subnet1_az" {
  description = "Availability Zone for the first public subnet"
  type        = string
  default     = "ap-northeast-1a"
}

variable "public_subnet1_name" {
  description = "Name of the first public subnet"
  type        = string
  default     = "Public-Subnet-1"
}

variable "public_subnet2_cidr_block" {
  description = "CIDR block for the second public subnet"
  type        = string
  default     = "192.168.2.0/24"
}

variable "public_subnet2_az" {
  description = "Availability Zone for the second public subnet"
  type        = string
  default     = "ap-northeast-1c"
}

variable "public_subnet2_name" {
  description = "Name of the second public subnet"
  type        = string
  default     = "Public-Subnet-2"
}

variable "private_subnet1_cidr_block" {
  description = "CIDR block for the first private subnet"
  type        = string
  default     = "192.168.101.0/24"
}

variable "private_subnet1_az" {
  description = "Availability Zone for the first private subnet"
  type        = string
  default     = "ap-northeast-1a"
}

variable "private_subnet1_name" {
  description = "Name of the first private subnet"
  type        = string
  default     = "Private-Subnet-1"
}

variable "private_subnet2_cidr_block" {
  description = "CIDR block for the second private subnet"
  type        = string
  default     = "192.168.102.0/24"
}

variable "private_subnet2_az" {
  description = "Availability Zone for the second private subnet"
  type        = string
  default     = "ap-northeast-1c"
}

variable "private_subnet2_name" {
  description = "Name of the second private subnet"
  type        = string
  default     = "Private-Subnet-2"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}


# CloudFront + S3
variable "s3_bucket_name" {
  description = "Name of S3 bucket for static content"
  type        = string
}
variable "domain_name" {
  description = "Domain name for the website"
  type        = string
}
variable "route53_zone_id" {
  description = "Route53 hosted zone ID"
  type        = string
}

# <-- biến cho RDS
variable "db_username" {
  description = "Master username for RDS"
  type        = string
  default     = "admin"
}
variable "db_password" {
  description = "Master password for RDS (sensitive)"
  type        = string
  sensitive   = true
}