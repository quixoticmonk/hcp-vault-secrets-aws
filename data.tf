data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  region                     = data.aws_region.current.name
  account_id                 = data.aws_caller_identity.current.account_id
  project_name               = "vault-secrets-demo"
  hcp_vault_secrets_app_name = "aws-app"
  external_id                = var.external_id
}