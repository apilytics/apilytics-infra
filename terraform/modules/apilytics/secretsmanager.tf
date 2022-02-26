resource "aws_secretsmanager_secret" "rds" {
  name       = "${var.name}-rds"
  kms_key_id = data.aws_kms_key.this.id
}

resource "aws_secretsmanager_secret_version" "rds" {
  secret_id = aws_secretsmanager_secret.rds.id
  secret_string = jsonencode({
    "username" : aws_db_instance.this.username,
    "password" : aws_db_instance.this.password,
  })
}

data "aws_kms_key" "this" {
  key_id = "alias/aws/secretsmanager"
}
