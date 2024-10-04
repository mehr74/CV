terraform {
  required_version = ">=0.13"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0.0"
    }
  }

  backend "s3" {
    bucket  = "coachcrew-terraform-state"
    key     = "personal/cv"
    region  = "eu-central-1"
    encrypt = true
  }
}

provider "aws" {
  region = var.region
}