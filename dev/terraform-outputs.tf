/*output "ec2_instances" {
  value = {
    for name, instance in module.ec2_instances :
    name => {
      instance_id = instance.id
      private_ip  = instance.private_ip
    }
  }
}*/