# Networking
variable "vpc_cidr_block" {
  default = "192.168.0.0/16"
}
variable "vpc_name" {
  default = "Main-VPC"
}
variable "public_subnet1_cidr_block" {
  default = "192.168.1.0/24"
}
variable "public_subnet1_az" {
  default = "ap-northeast-1a"
}
variable "public_subnet1_name" {
  default = "Public-Subnet-1"
}
variable "public_subnet2_cidr_block" {
  default = "192.168.2.0/24"
}
variable "public_subnet2_az" {
  default = "ap-northeast-1c"
}
variable "public_subnet2_name" {
  default = "Public-Subnet-2"
}
variable "private_subnet1_cidr_block" {
  default = "192.168.101.0/24"
}
variable "private_subnet1_az" {
  default = "ap-northeast-1a"
}
variable "private_subnet1_name" {
  default = "Private-Subnet-1"
}
variable "private_subnet2_cidr_block" {
  default = "192.168.102.0/24"
}
variable "private_subnet2_az" {
  default = "ap-northeast-1c"
}
variable "private_subnet2_name" {
  default = "Private-Subnet-2"
}

# Compute
variable "ami_id" {
  type = string
}
variable "key_name" {
  type = string
}
variable "instance_type" {
  default = "t3.small"
}
variable "desired_capacity" {
  default = 2
}
variable "min_size" {
  default = 1
}
variable "max_size" {
  default = 4
}
variable "ssh_allowed_cidr" {
  default = "130.62.216.135/32"
}

# Database
variable "db_identifier" {
  default = "mydb"
}
variable "db_engine" {
  default = "mysql"
}
variable "db_engine_version" {
  default = "8.0"
}
variable "db_instance_class" {
  default = "db.t3.micro"
}
variable "allocated_storage" {
  default = 20
}
variable "storage_type" {
  default = "gp3"
}
variable "db_username" {
  sensitive = true
}
variable "db_password" {
  sensitive = true
}
variable "multi_az" {
  default = true
}

# CDN
variable "domain_name" {
  type = string
}
variable "route53_zone_id" {
  type = string
}
variable "s3_bucket_name" {
  type = string
}