resource "aws_secretsmanager_secret" "rds" {
  name = "${var.name}-rds"
}

resource "aws_secretsmanager_secret_version" "rds" {
  secret_id = aws_secretsmanager_secret.rds.id
  secret_string = jsonencode({
    "username" : aws_db_instance.this.username,
    "password" : aws_db_instance.this.password,
    "engine" : aws_db_instance.this.engine,
    "host" : aws_db_instance.this.address,
    "port" : aws_db_instance.this.port,
    "dbInstanceIdentifier" : aws_db_instance.this.identifier,
  })
}

data "aws_kms_key" "this" {
  key_id = "alias/aws/secretsmanager"
}
