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
    # http = {
    #   source = "hashicorp/http"
    #   version = "3.4.5"
    # }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      environment = "Production" # lowercase will cause an issue
      Owner       = "Scott"
      ManagedBy   = "Terraform"
      Project     = "GitOps MiniCamp"
      unused_tag  = "this should cause an issue" # extra tag
    }
  }
}

# Adding a resource without proper tags
resource "aws_s3_bucket" "test" {
  bucket = "my-test-bucket"
  
  tags = {
    # Missing required tags will cause issues
    random_tag = "value"
  }
}