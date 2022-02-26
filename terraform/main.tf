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
