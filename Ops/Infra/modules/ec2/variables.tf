variable "ami_id" {
  description = "AMI ID to use for the instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type to use"
  type        = string
}

variable "key_name" {
  description = "Name of the key pair to use"
  type        = string
  default     = null
}

variable "instance_name" {
  description = "Name of the instance"
  type        = string
}

variable "volume_size" {
  description = "Size of the root volume"
  type        = number
  default     = 30
}

variable "user_data_script" {
  description = "Path to user data script"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to the instance"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "VPC ID to use for the instance"
  type        = string
}

 variable "sg_id" {
  description = "Security Group ID"
  type        = string
  default     = ""
 }

 variable "subnet_id" {
  description = "Subnet ID for the instance"
  type        = string
}

variable "security_group_id" {
  description = "Security Group ID"
  type        = string
  default     = ""
  
}