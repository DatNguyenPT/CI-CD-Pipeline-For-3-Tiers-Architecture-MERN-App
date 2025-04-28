resource "aws_security_group" "server_access_sg" {
  for_each    = var.config
  name        = "${each.key}-sg"
  description = "The security group for ${each.key}"
  vpc_id      = var.vpc_id

  # Add ingress rules based on the ports configuration
  dynamic "ingress" {
    for_each = each.value.ports
    content {
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = "tcp"
      cidr_blocks = ingress.value.source == "::/0" ? null : [ingress.value.source]
      ipv6_cidr_blocks = ingress.value.source == "::/0" ? [ingress.value.source] : null
    }
  }

  # Add a default egress rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Server"   = each.key
    "Provider" = "Terraform"
  }
}