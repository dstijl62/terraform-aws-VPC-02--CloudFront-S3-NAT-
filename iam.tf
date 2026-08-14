# IAM Role để EC2 có thể lấy secret từ Secrets Manager (hoặc ghi log)
resource "aws_iam_role" "ec2_role" {
  name = "ec2-web-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Gán policy cho phép đọc Secrets Manager (nếu bạn lưu password ở đó)
resource "aws_iam_policy" "secrets_manager_policy" {
  name        = "ec2-secrets-manager-policy"
  description = "Allow EC2 to read secrets from Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = "arn:aws:secretsmanager:ap-northeast-1:*:secret:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_secrets" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.secrets_manager_policy.arn
}

# Instance Profile để gán vào Launch Template
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-web-profile"
  role = aws_iam_role.ec2_role.name
}