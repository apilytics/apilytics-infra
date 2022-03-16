resource "aws_launch_configuration" "this" {
  name_prefix          = "${var.name}-lc"
  image_id             = data.aws_ssm_parameter.ecs_ami_id.value
  instance_type        = "t2.micro"
  user_data            = "#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.this.name} >> /etc/ecs/ecs.config"
  security_groups      = [aws_security_group.this.id]
  iam_instance_profile = aws_iam_instance_profile.ecs_instance.id

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_ssm_parameter" "ecs_ami_id" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}
