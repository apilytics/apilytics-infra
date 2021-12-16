terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.40.0"
    }
  }

  backend "s3" {
    // The state bucket has been created manually outside of terraform.
    bucket  = "apilytics-terraform-state"
    key     = "terraform.tfstate"
    encrypt = true
  }
}

// The IAM user that the repo is using has been created manually outside of Terraform.

locals {
  name = "apilytics"
}

module "landing_page_prod" {
  source = "./modules/landing-page"

  name = "${local.name}-prod-landing-page"

  vpc_cidr_block = "10.0.0.0/16"
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

  postgres_dbname   = var.landing_page_prod_postgres_dbname
  postgres_username = var.landing_page_prod_postgres_username
  postgres_password = var.landing_page_prod_postgres_password
}
