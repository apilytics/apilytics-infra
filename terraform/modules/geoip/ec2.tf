resource "aws_launch_template" "this" {
  name                   = "${var.name}-lt"
  image_id               = data.aws_ssm_parameter.ecs_ami_id.value
  instance_type          = local.instance_type
  user_data              = base64encode("#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.this.name} >> /etc/ecs/ecs.config")
  vpc_security_group_ids = [aws_security_group.instance.id]

  iam_instance_profile {
    arn = aws_iam_instance_profile.ecs_instance.arn
  }
}

data "aws_ssm_parameter" "ecs_ami_id" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}
