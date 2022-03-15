locals {
  container_name = replace(var.name, "-", "_")
}

resource "aws_ecs_cluster" "this" {
  name = "${var.name}-cluster"
}

resource "aws_ecs_service" "this" {
  name                               = "${var.name}-service"
  cluster                            = aws_ecs_cluster.this.id
  task_definition                    = aws_ecs_task_definition.this.family
  desired_count                      = 1
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = local.container_name
    container_port   = 8000
  }
}

resource "aws_ecs_task_definition" "this" {
  family             = "${var.name}-task"
  execution_role_arn = aws_iam_role.ecs_execution.arn
  container_definitions = jsonencode(
    [
      {
        name : local.container_name,
        image : "${replace(aws_ecr_repository.this.repository_url, "https://", "")}:${data.external.latest_ecr_tag.result["tag"]}",
        cpu : data.aws_ec2_instance_type.this.default_vcpus * 1024 / 2,
        memoryReservation : data.aws_ec2_instance_type.this.memory_size / 2,
        portMappings : [
          {
            containerPort : 8000,
            protocol : "tcp"
          }
        ],
        logConfiguration : {
          logDriver : "awslogs",
          options : {
            "awslogs-group" : aws_cloudwatch_log_group.this.name,
            "awslogs-region" : data.aws_region.current,
          }
        },
        essential : true,
        secrets : [
          {
            name : "API_KEY",
            valueFrom : aws_ssm_parameter.api_key.arn,
          },
        ]
      },
    ]
  )
}

data "aws_region" "current" {}

data "aws_ec2_instance_type" "this" {
  instance_type = aws_launch_configuration.this.instance_type
}

data "external" "latest_ecr_tag" {
  program = ["${path.root}/../scripts/get_latest_ecr_tag.sh", aws_ecr_repository.this.name]
}
