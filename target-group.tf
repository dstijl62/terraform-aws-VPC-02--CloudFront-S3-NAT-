resource "aws_lb_target_group" "web_tg" {
  name        = "web-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.main.id

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
