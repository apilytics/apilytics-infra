locals {
  container_name = replace(var.name, "-", "_")
  container_port = 8000
  instance_type  = "t2.micro"
}
