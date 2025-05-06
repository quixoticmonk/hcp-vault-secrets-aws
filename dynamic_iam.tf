# AWS IAM OIDC Identity Provider for HCP Vault
locals {
  organization_id = var.hcp_org_id
  project_id      = var.hcp_project_id
  issuer          = "idp.hashicorp.com/oidc/organization/${local.organization_id}"
  audience        = "arn:aws:iam::${local.account_id}:oidc-provider/${local.issuer}"
  subject         = "project:${local.project_id}:geo:us:service:vault-secrets:type:integration:name:aws1"
}

resource "aws_iam_openid_connect_provider" "hcp_vault_secrets" {
  url             = "https://${local.issuer}"
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"]
  client_id_list  = [local.audience]
}

resource "aws_iam_role" "integration_role" {
  name = "hcp-vault-secrets-integration"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.hcp_vault_secrets.arn
        }
        Condition = {
          StringEquals = {
            "${local.issuer}:sub" = local.subject
          }
        }
      }
    ]
  })
}

data "aws_iam_policy" "iam_full_access_policy" {
  name = "IAMFullAccess"
}

resource "aws_iam_role_policy_attachment" "integration_role_policy_attachment" {
  role       = aws_iam_role.integration_role.name
  policy_arn = data.aws_iam_policy.iam_full_access_policy.arn
}

resource "aws_iam_role" "dynamic_secret_role" {
  name = "hcp-vault-secrets-dynamic-secret"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "AWS" : aws_iam_role.integration_role.arn
        },
        "Condition" : {}
      }
    ]
  })
}

resource "aws_iam_role_policy" "dynamic_secret_policy" {
  name ="dynamic-secrets-policy"
  role = aws_iam_role.dynamic_secret_role.id
  policy = data.aws_iam_policy_document.dynamic_secret_policy.json
}


data "aws_iam_policy_document" "dynamic_secret_policy" {
  # Replace with the permissions to grant to your dynamic secret
  statement {
    effect = "Allow"
    actions = [
      "s3:List*"
    ]
    resources = ["*"]
  }
}