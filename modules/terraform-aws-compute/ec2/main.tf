locals {
  owner       = "glimmer"
  module_name = "${var.env}-${local.owner}"

  instances = flatten([
    for srv in var.configuration : [
      for i in range(1, srv.no_of_instances + 1) : {
        instance_name           = "${srv.instance_name}"
        instance_type           = srv.instance_type
        subnet_id               = srv.subnet_id
        ami                     = srv.ami
        security_groups         = srv.vpc_security_group_ids
        ssh_key_name            = srv.ssh_key_name
        ssh_key_pair            = srv.ssh_key_pair
        volume_size             = srv.volume_size
        volume_type             = srv.volume_type
        volume_iops             = try(srv.volume_iops, null)
        public_ip               = srv.public_ip
        source_dest_check       = srv.source_dest_check
        user_data_template      = srv.user_data_template
        delete_on_termination   = srv.delete_on_termination
        disable_api_termination = srv.disable_api_termination
        tags                    = srv.tags
      }
    ]
  ])
}

# An IAM role that we attach to the EC2 Instances in the cluster
resource "aws_iam_role" "ec2_instance" {
  name               = "ec2-instance"
  assume_role_policy = file("${path.module}/policies/ec2-instance.json")

  lifecycle { create_before_destroy = true }
}

resource "aws_iam_instance_profile" "ec2_instance" {
  name = "ec2-instance"
  role = aws_iam_role.ec2_instance.name
  lifecycle { create_before_destroy = true }
}

resource "aws_iam_role_policy" "ec2_instance_policy" {
  name   = "ec2-instance-policy"
  role   = aws_iam_role.ec2_instance.id
  policy = file("${path.module}/policies/ec2-instance-policy.json")

  lifecycle { create_before_destroy = true }
}
resource "tls_private_key" "sh_common_dev_key" {
  algorithm = "RSA"
}

#define key-pair for ec2-instance
resource "aws_key_pair" "awsKey" {
  for_each   = { for server in local.instances : server.instance_name => server }
  key_name   = each.value.ssh_key_name
  public_key = each.value.ssh_key_pair
}

// Configure the EC2 instance in a public subnet
module "default_instance" {
  source   = "terraform-aws-modules/ec2-instance/aws"
  for_each = { for server in local.instances : server.instance_name => server }

  name                        = each.value.instance_name
  ami                         = each.value.ami
  associate_public_ip_address = each.value.public_ip
  instance_type               = each.value.instance_type
  key_name                    = each.value.ssh_key_name
  user_data                   = each.value.user_data_template
  subnet_id                   = each.value.subnet_id
  vpc_security_group_ids      = each.value.security_groups
  iam_instance_profile        = aws_iam_instance_profile.ec2_instance.name
  source_dest_check           = each.value.source_dest_check
  create_security_group       = false
  disable_api_termination     = each.value.disable_api_termination

  enable_volume_tags = false
  root_block_device = {
    type                  = each.value.volume_type
    size                  = each.value.volume_size
    iops                  = each.value.volume_iops
    delete_on_termination = each.value.delete_on_termination
  }
  tags = each.value.tags
}
