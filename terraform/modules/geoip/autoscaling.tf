resource "aws_autoscaling_group" "prod" {
  name                = "${var.name}-asg"
  desired_capacity    = 1
  min_size            = 1
  max_size            = 2
  vpc_zone_identifier = values(aws_subnet.public)[*].id

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.name}-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
