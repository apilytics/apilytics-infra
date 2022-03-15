locals {
  ecr_policy_keep_10 = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Only keep the 10 latest images",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 10
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}

resource "aws_ecr_repository" "this" {
  name = var.name
}

resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name
  policy     = local.ecr_policy_keep_10
}
