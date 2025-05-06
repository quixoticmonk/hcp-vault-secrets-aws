# Create an HCP Vault Secrets application
resource "hcp_vault_secrets_app" "app" {
  app_name    = local.hcp_vault_secrets_app_name
  description = "Application for AWS Secrets Manager integration"
}

resource "hcp_vault_secrets_secret" "secret" {
  app_name     = hcp_vault_secrets_app.app.app_name
  secret_name  = "example_secret"
  secret_value = "hashi123"
}


resource "hcp_vault_secrets_integration" "aws" {
  name          = "aws1"
  capabilities  = ["DYNAMIC", "ROTATION"]
  provider_type = "aws"
  aws_federated_workload_identity = {
    audience = aws_iam_openid_connect_provider.hcp_vault_secrets.arn
    role_arn = aws_iam_role.integration_role.arn
  }
  depends_on = [aws_iam_role.dynamic_secret_role]
}