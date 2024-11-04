plugin "aws" {
  enabled = true
  version = "0.27.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

rule "aws_resource_missing_tags" {
  enabled = true
  tags = [
    "Environment",
    "Owner",
    "ManagedBy",
    "Project"
  ]
}
