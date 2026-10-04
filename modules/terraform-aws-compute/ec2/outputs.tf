output "default_instance_public_ip" {
  value = {
    for k, instance_details in module.default_instance : k => instance_details.public_ip
  }
}
output "default_instance_private_ip" {
  value = {
    for k, instance_details in module.default_instance : k => instance_details.private_ip
  }
}

output "default_instance_id" {
  description = "The ID of the instance"
  value = {
    for k, instance_details in module.default_instance : k => instance_details.id
  }
}
