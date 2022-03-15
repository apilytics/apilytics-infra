resource "aws_launch_configuration" "this" {
  name_prefix          = "${var.name}-lc"
  image_id             = data.aws_ami.amazon_linux_2.id
  instance_type        = "t2.micro"
  user_data            = "#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.this.name} >> /etc/ecs/ecs.config"
  security_groups      = [aws_security_group.this.id]
  iam_instance_profile = aws_iam_instance_profile.ecs_instance.id

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_ami" "amazon_linux_2" {
  owners      = ["amazon"]
  name_regex  = "^amzn2-ami-kernel-5.10-hvm-2.0.20220310.0-x86_64-gp2$"
  most_recent = true
}
