# prefix
variable "prefix" {
  type        = string
  default     = "group06"
  description = "prefix"
}


# Default tags
variable "default_tags" {
  default = {
    "Owner" = "group06",
    "App"   = "Web"
  }
  type        = map(any)
  description = "Default tags"
}


variable "env" {
  default     = "prod"
  type        = string
  description = "Environment"
}


# VPC CIDR range
variable "vpc_cidr" {
  default     = "10.30.0.0/16"
  type        = string
  description = "VPC for production machines"
}


variable "public_subnet_cidrs" {
  default     = ["10.30.1.0/24", "10.30.2.0/24", "10.30.3.0/24"]
  type        = list(string)
  description = "Public Subnet CIDRs for Prod env"
}



variable "private_subnet_cidrs" {
  default     = ["10.30.4.0/24", "10.30.5.0/24", "10.30.6.0/24"]
  type        = list(string)
  description = "Private Subnet CIDRs for Prod env"
}

