resource "aws_iam_policy" "get_parameters" {
  name   = "${var.name}-get-parameters"
  policy = data.aws_iam_policy_document.get_parameters.json
}

resource "aws_iam_role" "ecs_instance" {
  name               = "${var.name}-ecs-instance-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_ec2.json
}

resource "aws_iam_role" "ecs_execution" {
  name               = "${var.name}-ecs-execution-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_ecs_tasks.json
}

resource "aws_iam_role_policy_attachment" "ecs_instance" {
  role       = aws_iam_role.ecs_instance.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ecs_execution_1" {
  role       = aws_iam_role.ecs_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_execution_2" {
  role       = aws_iam_role.ecs_execution.name
  policy_arn = aws_iam_policy.get_parameters.arn
}

resource "aws_iam_instance_profile" "ecs_instance" {
  name = "${var.name}-ecs-instance-profile"
  path = "/"
  role = aws_iam_role.ecs_instance.id

  provisioner "local-exec" {
    # https://github.com/hashicorp/terraform/issues/2349#issuecomment-114168159
    command = "sleep 10"
  }
}

data "aws_iam_policy_document" "assume_ec2" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "assume_ecs_tasks" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "get_parameters" {
  statement {
    actions   = ["ssm:GetParameters"]
    resources = [aws_ssm_parameter.api_key.arn]
  }
}
