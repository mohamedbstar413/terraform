resource "aws_autoscaling_group" "book_back_ec2_asg" {
  max_size =                    var.asg_max_size
  min_size =                    var.asg_min_size
  desired_capacity =            var.asg_desired_size
  availability_zones =          [var.az_1, var.az_2]
  target_group_arns =           [aws_lb_target_group.book_back_ec2_target_group.arn]
  
  launch_template {
    id =                        aws_launch_template.book_backend_ec2_launch_template.id
  }
}


# Scale Out Policy (add 1 instance)
resource "aws_autoscaling_policy" "scale_out" {
  name                   = "scale-out"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.book_back_ec2_asg.name
}

# Scale In Policy (remove 1 instance)
resource "aws_autoscaling_policy" "scale_in" {
  name                   = "scale-in"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.book_back_ec2_asg.name
}