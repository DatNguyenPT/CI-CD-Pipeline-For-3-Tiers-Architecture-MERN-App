variable "instance_id" {
  description = "ID of the EC2 instance to associate with EIP"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to the EIP"
  type        = map(string)
  default     = {}
}