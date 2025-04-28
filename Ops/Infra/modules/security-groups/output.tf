output "security_groups" {
  description = "Map of security group IDs"
  value = {
    for name, sg in aws_security_group.server_access_sg : "${name}-sg" => sg.id
  }
}