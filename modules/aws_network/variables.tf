# Default tags
variable "default_tags" {
  default     = {}
  type        = map(any)
  description = "Default tags"
}

# prefix
variable "prefix" {
  type        = string
  description = "prefix"
}

# Variable to signal the current environment 
variable "env" {
  type        = string
  description = "Environment"
}

# VPC CIDR range
variable "vpc_cidr" {
  type        = string
  description = "VPC to host static web site"
}

# Provision public subnets in custom VPC
variable "public_cidr_blocks" {
  type        = list(string)
  description = "Public Subnet CIDRs"
}

# Provision private subnets in custom VPC
variable "private_cidr_blocks" {
  type        = list(string)
  description = "Private Subnet CIDRs"
}


