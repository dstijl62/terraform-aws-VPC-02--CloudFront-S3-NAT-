
# Alarm scale-out (CPU > 80%)

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 80

  alarm_actions = [
    aws_autoscaling_policy.cpu_scale_out.arn
  ]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }
}

# Alarm scale-in (CPU < 20%)

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "cpu-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 20

  alarm_actions = [
    aws_autoscaling_policy.cpu_scale_in.arn
  ]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }
}
