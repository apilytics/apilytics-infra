resource "aws_db_instance" "this" {
  identifier            = "${var.name}-rds"
  name                  = var.postgres_dbname
  engine                = "postgres"
  engine_version        = "12.8"
  instance_class        = "db.t4g.micro"
  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp2"
  storage_encrypted     = true
  username              = var.postgres_username
  password              = var.postgres_password

  db_subnet_group_name   = aws_db_subnet_group.this.name
  parameter_group_name   = "default.postgres12"
  vpc_security_group_ids = [aws_security_group.this.id]
  publicly_accessible    = true

  final_snapshot_identifier = "${var.name}-final-snapshot"
  backup_window             = "03:00-03:30"
  maintenance_window        = "Mon:03:30-Mon:04:00"
  backup_retention_period   = 14

  deletion_protection = true
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-landing-page-rds-subnet-group" # Cannot rename this trivially.
  subnet_ids = values(aws_subnet.public)[*].id
}

resource "aws_db_proxy" "this" {
  name           = "${var.name}-rds-proxy"
  engine_family  = "POSTGRESQL"
  role_arn       = aws_iam_role.rds_secret.arn
  vpc_subnet_ids = aws_db_subnet_group.this.subnet_ids

  auth {
    auth_scheme = "SECRETS"
    secret_arn  = aws_secretsmanager_secret.rds.arn
  }

  vpc_security_group_ids = [aws_security_group.this.id]
}

resource "aws_db_proxy_default_target_group" "this" {
  db_proxy_name = aws_db_proxy.this.name
}

resource "aws_db_proxy_target" "this" {
  db_instance_identifier = aws_db_instance.this.id
  db_proxy_name          = aws_db_proxy.this.name
  target_group_name      = aws_db_proxy_default_target_group.this.name
}
