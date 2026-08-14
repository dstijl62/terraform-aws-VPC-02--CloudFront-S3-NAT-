resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "EC2 behind ALB"
  vpc_id      = aws_vpc.main.id

  # Chỉ nhận HTTP từ ALB
  ingress {
    description = "HTTP from ALB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [
      aws_security_group.alb_sg.id
    ]
  }

  # SSH (tùy chọn)
  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["130.62.216.135/32"] # ❗ Không dùng 0.0.0.0/0
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}
