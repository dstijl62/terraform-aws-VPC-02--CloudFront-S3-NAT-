resource "aws_autoscaling_group" "web_asg" {
  name                = "web-asg"
  desired_capacity    = 2
  min_size            = 1
  max_size            = 4
  vpc_zone_identifier = [aws_subnet.private1.id, aws_subnet.private2.id]

  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }

  target_group_arns = [
    aws_lb_target_group.web_tg.arn
  ]

  health_check_type         = "EC2"
  health_check_grace_period = 30

  tag {
    key                 = "Name"
    value               = "web-instance"
    propagate_at_launch = true
  }
}
