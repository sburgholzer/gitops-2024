output "grafana_ip" {
  value = "http://${aws_instance.grafana_server.public_ip}:3000"
}

output "validation_success" {
  value = <<EOT
✅ AWS Environment Validation Successful:
   - Region: ${data.aws_region.current.name}
   - Account ID: ${data.aws_caller_identity.current.account_id}
EOT

  precondition {
    condition     = data.aws_region.current.name == var.expected_region && data.aws_caller_identity.current.account_id == var.expected_account_id
    error_message = "AWS environment validation failed"
  }
}
