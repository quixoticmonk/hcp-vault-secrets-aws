output "vault_secrets_app_id" {
  description = "ID of the HCP Vault Secrets application"
  value       = hcp_vault_secrets_app.app.id
}

output "vault_secrets_integration_role" {
  description = "ARN of the IAM role for HCP Vault Secrets"
  value       = aws_iam_role.integration_role.arn
}

output "vault_secrets_dynamic_role" {
  description = "ARN od the IAM role for Dynamic secrets management"
  value       = aws_iam_role.dynamic_secret_role.arn
}

output "vault_secrets_sync_role" {
  description = "ARN of the IAM role for Sync secrets management"
  value       = aws_iam_role.sync_role.arn
}