# Default tags
variable "default_tags" {
  default = {
    "Owner" = "group06"
    "App"   = "Web"
  }
}


#Environment
variable "env" {
  default     = "dev"
  type        = string
  description = "Environment"
}



variable "prefix" {
  type    = string
  default = "group06"
}

# VPC CIDR range
variable "vpc_cidr" {
  default     = "10.100.0.0/16"
  type        = string
  description = "vpc dev"
}


variable "public_cidr_blocks" {
  default     = ["10.100.1.0/24", "10.100.2.0/24"]
  type        = list(string)
  description = "Public Subnet CIDRs for dev environment"
}



variable "private_cidr_blocks" {
  default     = ["10.100.3.0/24", "10.100.4.0/24"]
  type        = list(string)
  description = "Private Subnet CIDRs for dev environment"
}


