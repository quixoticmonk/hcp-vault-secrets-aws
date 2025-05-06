# Create an IAM role that HCP Vault Secrets can assume

resource "aws_iam_role" "sync_role" {
  name = "${local.project_name}-sync-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::879554817125:role/HCPVaultSecrets_Sync"
        }
        Condition = {
          StringEquals = {
            "sts:ExternalId" = local.external_id
          }
        }
      }
    ]
  })

  tags = {
    Name = "${local.project_name}-vault-secrets-role"
  }
}

# Create an IAM policy for Secrets Manager access
resource "aws_iam_policy" "secrets_manager_policy" {
  name        = "${local.project_name}-secrets-manager-policy"
  description = "Policy for HCP Vault Secrets to access AWS Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "secretsmanager:DescribeSecret",
          "secretsmanager:GetSecretValue",
          "secretsmanager:CreateSecret",
          "secretsmanager:PutSecretValue",
          "secretsmanager:UpdateSecret",
          "secretsmanager:UpdateSecretVersionStage",
          "secretsmanager:DeleteSecret",
          "secretsmanager:RestoreSecret",
          "secretsmanager:TagResource",
          "secretsmanager:UntagResource"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "secrets_manager_attachment" {
  role       = aws_iam_role.sync_role.name
  policy_arn = aws_iam_policy.secrets_manager_policy.arn
}
