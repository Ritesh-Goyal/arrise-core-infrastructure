provider "aws" {
  region = var.region
  assume_role {
    role_arn     = "arn:aws:iam::480545061213:role/ExternalAdminRole"
    session_name = "terraform-user"
    external_id  = "arrise_terraform_id"
  }
}

terraform {
  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = "~> 6.0"
    }

    template = {
      source  = "cloudposse/template"
      version = "~> 2.2.0"
    }
  }

  required_version = ">= 1.8"
}