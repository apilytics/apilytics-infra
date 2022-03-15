resource "aws_autoscaling_group" "prod" {
  name                 = "${var.name}-asg"
  desired_capacity     = 1
  min_size             = 1
  max_size             = 2
  launch_configuration = aws_launch_configuration.this.name
  vpc_zone_identifier  = values(aws_subnet.public)[*].id

  tag {
    key                 = "Name"
    value               = "${var.name}-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
