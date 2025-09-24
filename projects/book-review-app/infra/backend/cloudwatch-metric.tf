resource "aws_cloudwatch_metric_alarm" "book_high_cpu" {
  alarm_name        = "high-cpu-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 70

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.book_back_ec2_asg.name
  }
  alarm_actions       = [aws_autoscaling_policy.scale_out.arn]
}

# CloudWatch Alarm - Low CPU (Scale In)
resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "cpu-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 30
  alarm_description   = "This alarm triggers when CPU < 30%"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.book_back_ec2_asg.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_in.arn]
}
