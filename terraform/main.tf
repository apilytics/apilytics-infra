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

module "geoip_prod" {
  source = "./modules/geoip"

  name                      = "${local.name}-geoip-prod"
  domain                    = "geoip.apilytics.io"
  api_key                   = var.geoip_prod_api_key
  vpc_cidr_block            = "10.0.0.0/16"
  public_subnet_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}
