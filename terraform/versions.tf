terraform {
  required_version = ">= 1.9.0"

  backend "s3" {} # We will be using partial configuration
}