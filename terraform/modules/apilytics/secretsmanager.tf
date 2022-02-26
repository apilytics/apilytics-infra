resource "aws_secretsmanager_secret" "rds" {
  name = "${var.name}-rds"
}

resource "aws_secretsmanager_secret_version" "rds" {
  secret_id = aws_secretsmanager_secret.rds.id
  secret_string = jsonencode({
    "username" : var.postgres_username,
    "password" : var.postgres_password,
  })
}

data "aws_kms_key" "this" {
  key_id = "alias/aws/secretsmanager"
}
