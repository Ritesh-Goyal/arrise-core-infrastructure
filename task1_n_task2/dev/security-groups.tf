// Security Group for VPN service
module "arrise_app_security_group" {
  source          = "../modules/terraform-aws-networking/security-groups"
  name            = "arrise-dev-app-sg"
  description     = "Security group for arrise-dev-app"
  vpc_id          = module.networking.vpc.vpc_id
  use_name_prefix = false

  ingress_with_cidr_blocks = [
    {
      description = "Access within same network"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "10.11.0.0/20"
    }
  ]
  ingress_with_source_security_group_id = [
    {
      description              = "HTTP access from the internet"
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      source_security_group_id = module.arrise_web_security_group.security_group_id
    },
    {
      description              = "HTTP access from the internet"
      from_port                = 8080
      to_port                  = 8080
      protocol                 = "tcp"
      source_security_group_id = module.arrise_web_security_group.security_group_id
    }
  ]
  egress_with_cidr_blocks = [
    {
      description = "Allow all outbound connections"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

module "arrise_web_security_group" {
  source          = "../modules/terraform-aws-networking/security-groups"
  name            = "arrise-dev-web-sg"
  description     = "Security group for arrise-dev-web"
  vpc_id          = module.networking.vpc.vpc_id
  use_name_prefix = false

  ingress_with_cidr_blocks = [
    {
      description = "Access within same network"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "10.11.240.0/24"
    },
    {
      description = "Access within same network"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = "10.11.240.0/24"
    },
    {
      description = "Access within same network"
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = "10.11.240.0/24"
    }
  ]
  ingress_with_source_security_group_id = [
    {
      description              = "HTTP access from the internet"
      from_port                = 443
      to_port                  = 443
      protocol                 = "tcp"
      source_security_group_id = module.arrise_bastion_security_group.security_group_id
    }
  ]
  egress_with_cidr_blocks = [
    {
      description = "Allow all outbound connections"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

// Security Group for ALB
module "arrise_bastion_security_group" {
  source = "../modules/terraform-aws-networking/security-groups"

  name            = "arrise-dev-bastion"
  use_name_prefix = false
  description     = "Security group for Bastion Host"
  vpc_id          = module.networking.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp"]
  ingress_with_cidr_blocks = [
    {
      description = "SSH access publicly"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      description = "Allow all outbound connections"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}
