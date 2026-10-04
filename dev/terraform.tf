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