output "vpc" {
  value = module.vpc
}
output "public_subnets_ids" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}
output "private_subnets_ids" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}
