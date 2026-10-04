terraform {
  backend "s3" {
    bucket  = "arrise-dev-infrastructure-terraform-tfstates"
    key     = "roles/terraform.tfstate"
    region  = "us-east-1"
    profile = "dev"
  }
}