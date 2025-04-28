variable "azs" {
  description = "List of Availability Zones"
  type        = list(string)
  default     = ["us-east-1a"]  
}

variable "region" {
  type        = string
  description = "AWS Default Region"
  default     = "us-east-1"
}


variable "tags" {
  description = "Tags to be applied to the EIP"
  type        = map(string)
}


variable "vpc_id" {
  description = "VPC ID where the IGW and Route Table will be created"
  type        = string
}


variable "route_table_name" {
  description = "Name tag for the Public Route Table"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs to associate with the route table"
  type        = list(string)
}

variable "name" {
  description = "VPC Name"
  type        = string
}

variable "cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "azs" {
  description = "AZs"
  type        = list(string)
}

variable "private_subnets" {
  description = "Private Subnets"
  type        = list(string)
}

variable "public_subnets" {
  description = "Public Subnets"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway"
  type        = bool
}

variable "single_nat_gateway" {
  description = "1 Nat Gateway Only"
  type        = bool
}

variable "tags" {
  description = "Tags"
  type        = map(string)
}




