# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "5.69.0"
#     }
#     # http = {
#     #   source = "hashicorp/http"
#     #   version = "3.4.5"
#     # }
#   }
# }

# provider "aws" {
#   region = var.region
#   default_tags {
#     tags = {
#       Environment = "Production" # as we only run apply right now on production ready code
#       Owner       = "Scott"
#       ManagedBy   = "Terraform"
#       Project     = "GitOps MiniCamp"
#     }
#   }
# }


## Intentonal code to cause TFLint to fail
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.69.0"
    }
  }
}

# Unused variable
variable "unused_var" {
  type = string
  default = "this will cause an error"
}

# Duplicate resource names
resource "aws_s3_bucket" "example" {
  bucket = "my-bucket-1"
}

resource "aws_s3_bucket" "example" {
  bucket = "my-bucket-2"
}

# Invalid interpolation syntax
resource "aws_instance" "bad_syntax" {
  ami           = "${var.ami_id"  # Missing closing brace
  instance_type = "${var.instance_type}}}"  # Extra closing braces
}

# Reference to undeclared variable
resource "aws_vpc" "main" {
  cidr_block = var.undefined_variable
}

# Unnecessary interpolation
resource "aws_subnet" "example" {
  vpc_id     = "${aws_vpc.main.id}"  # Unnecessary interpolation
  cidr_block = "${var.subnet_cidr}"  # Unnecessary interpolation
}