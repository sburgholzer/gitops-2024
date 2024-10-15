terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.69.0"
    }
  }

  backend "s3" {
    bucket         = "gitops-tf-backend-scott"
    key            = "state/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "GitopsTerraformLocks"
  }
}

provider "aws" {
  region = var.region
}