
# Tăng EC2 khi CPU > 80%

resource "aws_autoscaling_policy" "cpu_scale_out" {
  name                   = "cpu-scale-out"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 60
}



# Giảm EC2 khi CPU < 20%

resource "aws_autoscaling_policy" "cpu_scale_in" {
  name                   = "cpu-scale-in"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 60
}
