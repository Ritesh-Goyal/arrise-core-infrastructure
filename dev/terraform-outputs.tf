output "ec2_instances" {
  value = {
    for name, instance_id in module.ec2_instances.default_instance_id :
    name => {
      instance_id = instance_id
      private_ip  = module.ec2_instances.default_instance_private_ip[name]
    }
  }
}
