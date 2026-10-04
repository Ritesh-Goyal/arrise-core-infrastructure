terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  alias   = "account_a"
  region  = "us-east-1"
  profile = "account-a-admin"

  # Account A
}

provider "aws" {
  alias   = "account_b"
  region  = "us-east-1"
  profile = "account-b-admin"

  # Account B
}
