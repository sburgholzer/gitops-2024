variable "region" {
  type        = string
  description = "The region we are deploying our resources in"
}
variable "instance_type" {
  type        = string
  description = "The instance type for the EC2 instance"
}
variable "EXPECTED_REGION" {
  type        = string
  description = "The expected region for the resources"
}
variable "EXPECTED_ACCOUNT_ID" {
  type        = string
  description = "The expected AWS Account ID to validate against"
}