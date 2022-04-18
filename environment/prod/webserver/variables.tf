# Instance type
variable "instance_type" {
  default = {
    "prod"    = "t3.medium"
    "test"    = "t3.micro"
    "staging" = "t3.small"
    "dev"     = "t2.micro"
  }
  description = "Type of the instance"
  type        = map(string)
}

# Prefix
variable "prefix" {
  default     = "group06"
  type        = string
  description = "prefix"
}


# Default tags
variable "default_tags" {
  default = {
    "Owner" = "group06"
    "App"   = "Web"
  }
  type        = map(any)
  description = "Default tags"
}


# Variable to signal the current environment 
variable "env" {
  default     = "prod"
  type        = string
  description = "Environment"
}

variable "ec2_count" {
  type    = number
  default = "0"
}

variable "my_bastion_cidrs" {
  type        = string
  default     = "10.100.2.0/24"
  description = "Public IP of my Cloud 9 station to be opened in bastion ingress"
}

variable "desired_size" {
  type        = number
  description = "Desired size for ASG"
  default     = 3
}
