output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public Subnet IDs"
  value       = module.vpc.public_subnets
}

output "private_subent_ids" {
  description = "Private Subnet IDs"
  value       = module.vpc.public_subnets
}
