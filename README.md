# HCP Vault Secrets with AWS Secrets Manager Integration

This Terraform configuration sets up an integration between HCP Vault Secrets and AWS Secrets Manager using both IAM role-based authentication and OIDC identity provider for enhanced security.

## Prerequisites

- AWS account with appropriate permissions
- HCP account with Vault Secrets enabled
- Terraform installed (version >= 1.2.0)
- AWS CLI configured with appropriate credentials
- HCP credentials configured (HCP_CLIENT_ID and HCP_CLIENT_SECRET environment variables)
- HCP Organization ID and Project ID