module "networking" {
  source          = "../modules/terraform-aws-networking/"
  env             = var.env
  owner           = local.owner
  vpc_cidr        = var.vpc_cidr
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  network_acls = {

    "arrise_dev_private_nacl" = {
      vpc        = module.networking.vpc.vpc_id
      subnet_ids = module.networking.private_subnets_ids
      egress = [
        {
          protocol   = "tcp"
          rule_no    = 100
          action     = "allow"
          cidr_block = "0.0.0.0/0"
          from_port  = 80
          to_port    = 80
        },
        {
          protocol   = "tcp"
          rule_no    = 200
          action     = "allow"
          cidr_block = "0.0.0.0/0"
          from_port  = 443
          to_port    = 443

        },
        {
          protocol   = "tcp"
          rule_no    = 300
          action     = "allow"
          cidr_block = "0.0.0.0/0"
          from_port  = 22
          to_port    = 22

        },
        {
          protocol   = -1
          rule_no    = 400
          action     = "allow"
          cidr_block = "10.11.0.0/16"
          from_port  = 0
          to_port    = 0

        },
        {
          protocol   = -1
          rule_no    = 401
          action     = "allow"
          cidr_block = "10.20.0.0/16"
          from_port  = 0
          to_port    = 0

        },
        {
          protocol   = "tcp"
          rule_no    = 402
          action     = "allow"
          cidr_block = "0.0.0.0/0"
          from_port  = 1024
          to_port    = 65535

      }]
      ingress = [
        {
          protocol   = "tcp"
          rule_no    = 100
          action     = "allow"
          cidr_block = "10.11.0.0/16"
          from_port  = 80
          to_port    = 80
        },
        {
          protocol   = "tcp"
          rule_no    = 101
          action     = "allow"
          cidr_block = "10.11.0.0/16"
          from_port  = 22
          to_port    = 22
        },
        {
          protocol   = "tcp"
          rule_no    = 102
          action     = "allow"
          cidr_block = "10.20.0.0/16"
          from_port  = 22
          to_port    = 22
        },
        {
          protocol   = "tcp"
          rule_no    = 103
          action     = "allow"
          cidr_block = "10.20.0.0/16"
          from_port  = 443
          to_port    = 443
        },
        {
          protocol   = "tcp"
          rule_no    = 200
          action     = "allow"
          cidr_block = "10.11.0.0/16"
          from_port  = 443
          to_port    = 443
        },
        {
          protocol   = "tcp"
          rule_no    = 300
          action     = "allow"
          cidr_block = "10.11.0.0/16"
          from_port  = 1024
          to_port    = 65535
        },
        {
          protocol   = "tcp"
          rule_no    = 400
          action     = "allow"
          cidr_block = "0.0.0.0/0"
          from_port  = 1024
          to_port    = 65535
      }]
    }
    "arrise_dev_public_nacl" = {
      vpc        = module.networking.vpc.vpc_id
      subnet_ids = module.networking.public_subnets_ids
      egress = [
        {
          protocol   = -1
          rule_no    = 100
          action     = "allow"
          cidr_block = "0.0.0.0/0"
          from_port  = 0
          to_port    = 0

      }]
      ingress = [
        {
          protocol   = "udp"
          rule_no    = 100
          action     = "allow"
          cidr_block = "0.0.0.0/0"
          from_port  = 11092
          to_port    = 11092
        },
        {
          protocol   = -1
          rule_no    = 200
          action     = "allow"
          cidr_block = "0.0.0.0/0"
          from_port  = 0
          to_port    = 0
      }]
    }
  }
}

/*module "dev_uat_peering_connection" {
  source           = "git@github.com:storyhunter/terraform-aws-networking.git//peering?ref=main"
  env              = var.env
  region           = var.region
  peer_owner_id    = "870130602327"          //AWS UAT account id
  peer_vpc_id      = "vpc-0e62e13a87da1c54e" //AWS UAT VPC id
  requestor_vpc_id = module.networking.vpc.vpc_id

  peer_cidr_block          = "10.20.0.0/16"            // dev account vpc cidr
  route_table_id_requester = ["rtb-096b905daa720eb55"] // dev route table id

  destination_cidr_block_accepter = "10.11.0.0/16"            // UAT account vpc cidr
  route_table_id_accepter         = ["rtb-0e74915c3f9fa841b"] // UAT toute table id

  role_arn = "arn:aws:iam::870130602327:role/ExternalAdminRole"
}
*/