output "eip_id" {
  description = "ID of the created Elastic IP"
  value       = aws_eip.this.id
}

output "public_ip" {
  description = "Public IP address of the Elastic IP"
  value       = aws_eip.this.public_ip
}