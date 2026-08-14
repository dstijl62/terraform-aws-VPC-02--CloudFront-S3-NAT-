# Provider cho vùng chính (Tokyo) – dùng cho VPC, EC2, ALB, RDS, v.v.
provider "aws" {
  region = "ap-northeast-1"
}

# Provider cho ACM (CloudFront yêu cầu ACM ở us-east-1) – đã có trong acm.tf, giữ nguyên.