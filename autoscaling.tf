resource "aws_autoscaling_group" "example" {
  launch_template {
    id      = aws_launch_template.example.id
    version = "$Latest"
  }
  
  min_size = 1
  max_size = 4
  desired_capacity = 2
  
  vpc_zone_identifier = [
    aws_subnet.private-sub-1.id,
    aws_subnet.private-sub-2.id
  ]
  
  tag {
    key                 = "Name"
    value               = "example-asg-instance"
    propagate_at_launch = true
  }
}
