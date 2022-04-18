# Default tags
variable "default_tags" {
  default = {
    "Owner" = "group06"
    "App"   = "Web"
  }
}

variable "env" {
  default     = "staging"
  type        = string
  description = "Environment"
}


variable "prefix" {
  type    = string
  default = "group06"
}

# VPC CIDR range
variable "vpc_cidr" {
  default     = "10.200.0.0/16"
  type        = string
  description = "Staging VPC"
}


variable "public_cidr_blocks" {
  default     = ["10.200.1.0/24", "10.200.2.0/24", "10.200.3.0/24"]
  type        = list(string)
  description = "Public Subnet CIDRs for Staging env"
}


#private subnets in Staging VPC
variable "private_cidr_blocks" {
  default     = ["10.200.4.0/24", "10.200.5.0/24", "10.200.6.0/24"]
  type        = list(string)
  description = "Private Subnet CIDRs for Staging env"
}




