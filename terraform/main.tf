terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.70.0"
    }

    external = {
      source  = "hashicorp/external"
      version = "2.2.2"
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

  name             = "${local.name}-geoip-prod"
  domain           = "geoip.apilytics.io"
  api_key          = var.geoip_prod_api_key
  internal_api_key = var.internal_api_key
  vpc_cidr_block   = "10.0.0.0/16"
}
