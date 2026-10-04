module "ec2_instances" {
  source = "../modules/terraform-aws-compute/ec2"
  env    = var.env
  configuration = [
    {
      "instance_name" : "${local.module_name}-dev-app",
      "ami" : "ami-0d27e0fb3bac4d724", // Amazon Linux 2023 supported until June 2029
      "no_of_instances" : "1",
      "instance_type" : "t3.medium",
      "subnet_id" : module.networking.vpc.private_subnets[0],
      "vpc_security_group_ids" : [module.arrise_app_security_group.security_group_id],
      "public_ip" : "true",
      "volume_size" : "30",
      "volume_type" : "io1",
      "volume_iops" : 100,
      "delete_on_termination" : "false",
      "disable_api_termination" : "true",
      "source_dest_check" : "false",
      "user_data_template" : templatefile("${path.module}/user-data/AL2023_dev_instance_data.tpl", {}),
      "ssh_key_name" = "${local.module_name}-dev-app"
      "ssh_key_pair" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJdW32D26g0ZsRZNy0h91gwX80eS2NVv3B+uLrh/YuYK"
      "tags" : { "Name" = "${local.module_name}-dev-app", "Environment" = "${var.env}", "Owner" = "${local.owner}" }
    },
    {
      "instance_name" : "${local.module_name}-dev-web",
      "ami" : "ami-0d27e0fb3bac4d724", // Amazon Linux 2023 supported until June 2029
      "no_of_instances" : "1",
      "instance_type" : "t2.medium",
      "subnet_id" : module.networking.vpc.public_subnets[0],
      "vpc_security_group_ids" : [module.arrise_web_security_group.security_group_id],
      "public_ip" : "true",
      "volume_size" : "30",
      "volume_type" : "gp2",
      "delete_on_termination" : "true",
      "disable_api_termination" : "false",
      "source_dest_check" : "false",
      "user_data_template" : templatefile("${path.module}/user-data/AL2023_dev_instance_data.tpl", {}),
      "ssh_key_name" = "${local.module_name}-dev-web"
      "ssh_key_pair" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFUZmqT+NE3ap45JNPwQQepP2SCtYeOhrwJdFYkruYJC"
      "tags" : { "Name" = "${local.module_name}-dev-web", "Environment" = "${var.env}", "Owner" = "${local.owner}" }
    },
    {
      "instance_name" : "${local.module_name}-bastion",
      "ami" : "ami-0d27e0fb3bac4d724", // Amazon Linux 2023 supported until June 2029
      "no_of_instances" : "1",
      "instance_type" : "t2.small",
      "subnet_id" : module.networking.vpc.public_subnets[1],
      "vpc_security_group_ids" : [module.arrise_bastion_security_group.security_group_id],
      "public_ip" : "true",
      "volume_size" : "30",
      "volume_type" : "gp2",
      "delete_on_termination" : "true",
      "disable_api_termination" : "false",
      "source_dest_check" : "false",
      "user_data_template" : templatefile("${path.module}/user-data/AL2023_dev_instance_data.tpl", {}),
      "ssh_key_name" = "${local.module_name}-dev-bastion"
      "ssh_key_pair" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEAG5vCcSvp3glWnYDE8z7E8U7B5SL1IHneoCBxjMuDp"
      "tags" : { "Name" = "${local.module_name}-dev-bastion", "Environment" = "${var.env}", "Owner" = "${local.owner}" }
    }
  ]
}
