# Instance type
variable "instance_type" {
  default = {
    "prod"    = "t3.medium"
    "staging" = "t3.small"
    "dev"     = "t3.micro"
  }
  description = "Type of the instance"
  type        = map(string)
}

# Default tags
variable "default_tags" {
  default = {
    "Owner" = "group06"
    "App"   = "Web"
  }
}


variable "prefix" {
  type    = string
  default = "group06"
}


# Environment
variable "env" {
  default     = "dev"
  type        = string
  description = "Environment"
}

variable "ec2_count" {
  type    = number
  default = "0"
}

# Cloud9 Public IP
variable "my_public_ip" {
  type        = string
  description = "Public IP of my Cloud9"
  default     = "44.203.235.176"
}

# Cloud9 Private IP
variable "my_private_ip" {
  type        = string
  description = "Private IP of my Cloud9"
  default     = "172.31.9.163"
}

variable "desired_size" {
  type        = number
  description = "Desired ASG size"
  default     = 2
}
