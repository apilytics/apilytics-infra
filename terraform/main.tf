terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.70.0"
    }
  }

  backend "s3" {
    bucket         = "apilytics-terraform-state"
    key            = "terraform.tfstate"
    encrypt        = true
    dynamodb_table = "apilytics-terraform-lock"
  }
}

locals {
  name = "apilytics"
}

module "apilytics_prod" {
  source = "./modules/apilytics"

  name = "${local.name}-prod"

  vpc_cidr_block            = "10.0.0.0/16"
  public_subnet_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

  postgres_dbname   = var.prod_postgres_dbname
  postgres_username = var.prod_postgres_username
  postgres_password = var.prod_postgres_password
}
