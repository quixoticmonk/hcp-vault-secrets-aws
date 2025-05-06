terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
    hcp = {
      source = "hashicorp/hcp"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "hcp" {
}
