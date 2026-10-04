locals {
  owner       = "arrise"
  module_name = "${var.env}-${local.owner}"
  env         = "dev"
}

data "aws_caller_identity" "current" {}