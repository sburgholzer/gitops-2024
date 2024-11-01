variable "region" {
  type        = string
  description = "The region we are deploying our resources in"
}
variable "instance_type" {
  type        = string
  description = "The instance type for the EC2 instance"
}
variable "expected_region" {
  type        = string
  description = "The expected region for the resources"
}
variable "expected_account_id" {
  type        = string
  description = "The expected AWS Account ID to validate against"
}