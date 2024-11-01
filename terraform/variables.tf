# variable "region" {
#   type        = string
#   description = "The region we are deploying our resources in"
#   validation {
#     condition     = can(regex("^[a-z]{2}-(central|north|south|east|west|northeast|southeast|northwest|southwest)-[0-9]$", var.expected_region))
#     error_message = "The expected_region must be a valid AWS region format (e.g., us-east-1, eu-west-1)"
#   }
# }
# variable "instance_type" {
#   type        = string
#   description = "The instance type for the EC2 instance"
#   validation {
#     condition = contains([
#       "t2.micro", "t2.small"
#     ], var.expected_instance_type)
#     error_message = "The instance_type must be a valid and supported EC2 instance type"
#   }
# }
# variable "expected_region" {
#   type        = string
#   description = "The expected region for the resources"
#   validation {
#     condition     = can(regex("^[a-z]{2}-(central|north|south|east|west|northeast|southeast|northwest|southwest)-[0-9]$", var.expected_region))
#     error_message = "The expected_region must be a valid AWS region format (e.g., us-east-1, eu-west-1)"
#   }
# }
# variable "expected_account_id" {
#   type        = string
#   description = "The expected AWS Account ID to validate against"
#   validation {
#     condition     = can(regex("^\\d{12}$", var.expected_account_id))
#     error_message = "The Account ID must be a 12-digit number"
#   }
# }

variable "region" {
  type        = string
  description = "AWS region"
  
  validation {
    condition     = can(regex("^[a-z]{2}-(central|north|south|east|west|northeast|southeast|northwest|southwest)-[0-9]$", var.region))
    error_message = "Region must be a valid AWS region format (e.g., us-east-1)"
  }
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  
  validation {
    condition     = contains(["t2.micro", "t2.small"], var.instance_type)
    error_message = "Instance type must be either t2.micro or t2.small"
  }
}

variable "expected_region" {
  type        = string
  description = "Expected AWS region for validation"
}

variable "expected_account_id" {
  type        = string
  description = "Expected AWS account ID for validation"
}