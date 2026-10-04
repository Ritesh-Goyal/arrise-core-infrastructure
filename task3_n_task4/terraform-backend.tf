terraform {
  backend "s3" {
    bucket         = "arrise-core-infrastructure-terraform-state"
    key            = "environment/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "arrise-core-infrastructure-terraform-locks"
    encrypt        = true
  }
}
