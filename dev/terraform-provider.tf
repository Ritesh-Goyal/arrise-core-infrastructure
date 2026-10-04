provider "aws" {
  region = var.region
  assume_role {
    role_arn     = "arn:aws:iam::480545061213:role/ExternalAdminRole"
    session_name = "terraform-user"
    external_id  = "arrise_terraform_id"
  }
}