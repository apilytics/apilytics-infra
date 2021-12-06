resource "aws_db_instance" "this" {
  identifier        = "${var.name}-rds"
  name              = var.postgres_dbname
  engine            = "postgres"
  engine_version    = "13.4"
  instance_class    = "db.t2.micro"
  allocated_storage = 20
  storage_type      = "gp2"
  username          = var.postgres_password
  password          = var.postgres_username

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.this.id]
  publicly_accessible    = false

  final_snapshot_identifier = "${var.name}-final-snapshot"
  backup_window             = "03:00-03:30"
  maintenance_window        = "Mon:03:30-Mon:04:00"
  backup_retention_period   = 14

  deletion_protection = false
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-rds-subnet-group"
  subnet_ids = [aws_subnet.a.id, aws_subnet.b.id, aws_subnet.c.id]
}
