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
  description = "CIDR for public subnet 1"
  type        = string
  default     = "192.168.1.0/24"
}
variable "public_subnet1_az" {
  description = "AZ for public subnet 1"
  type        = string
  default     = "ap-northeast-1a"
}
variable "public_subnet1_name" {
  description = "Name for public subnet 1"
  type        = string
  default     = "Public-Subnet-1"
}

variable "public_subnet2_cidr_block" {
  description = "CIDR for public subnet 2"
  type        = string
  default     = "192.168.2.0/24"
}
variable "public_subnet2_az" {
  description = "AZ for public subnet 2"
  type        = string
  default     = "ap-northeast-1c"
}
variable "public_subnet2_name" {
  description = "Name for public subnet 2"
  type        = string
  default     = "Public-Subnet-2"
}

variable "private_subnet1_cidr_block" {
  description = "CIDR for private subnet 1"
  type        = string
  default     = "192.168.101.0/24"
}
variable "private_subnet1_az" {
  description = "AZ for private subnet 1"
  type        = string
  default     = "ap-northeast-1a"
}
variable "private_subnet1_name" {
  description = "Name for private subnet 1"
  type        = string
  default     = "Private-Subnet-1"
}

variable "private_subnet2_cidr_block" {
  description = "CIDR for private subnet 2"
  type        = string
  default     = "192.168.102.0/24"
}
variable "private_subnet2_az" {
  description = "AZ for private subnet 2"
  type        = string
  default     = "ap-northeast-1c"
}
variable "private_subnet2_name" {
  description = "Name for private subnet 2"
  type        = string
  default     = "Private-Subnet-2"
}