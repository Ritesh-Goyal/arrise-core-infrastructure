locals {
  owner       = var.owner
  module_name = "${var.env}-${local.owner}"
}
// TODO break public and private into separate AZs
data "aws_availability_zones" "available" {}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  version                       = "v6.6.0"
  name                          = "${local.module_name}-vpc"
  cidr                          = var.vpc_cidr
  azs                           = data.aws_availability_zones.available.names
  private_subnets               = var.private_subnets
  public_subnets                = var.public_subnets
  create_database_subnet_group  = true
  enable_nat_gateway            = true
  single_nat_gateway            = true
  enable_dns_hostnames          = true
  enable_dns_support            = true
  map_public_ip_on_launch       = true
  manage_default_security_group = false
  manage_default_network_acl    = false
  manage_default_route_table    = false
}

# Create NACL 
resource "aws_network_acl" "sh_nacl" {

  for_each = var.network_acls

  // name       = each.value["name"]
  vpc_id     = module.vpc.vpc_id
  subnet_ids = each.value["subnet_ids"]

  dynamic "egress" {
    for_each = each.value["egress"]

    content {
      protocol   = egress.value["protocol"]
      rule_no    = egress.value["rule_no"]
      action     = egress.value["action"]
      cidr_block = egress.value["cidr_block"]
      from_port  = egress.value["from_port"]
      to_port    = egress.value["to_port"]
    }
  }

  dynamic "ingress" {
    for_each = each.value["ingress"]

    content {
      protocol   = ingress.value["protocol"]
      rule_no    = ingress.value["rule_no"]
      action     = ingress.value["action"]
      cidr_block = ingress.value["cidr_block"]
      from_port  = ingress.value["from_port"]
      to_port    = ingress.value["to_port"]
    }
  }

  tags = {
    Name = each.key
  }

}
