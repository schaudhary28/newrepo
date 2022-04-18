# Default tags
variable "default_tags" {
  default     = {}
  type        = map(any)
  description = "Default tags for all AWS resources"
}

# prefix
variable "prefix" {
  type        = string
  description = "prefix"
}

# Instance type
variable "instance_type" {
  description = "Type of the instance"
  type        = map(string)
}

# Variable to signal the current environment 
variable "env" {
  type        = string
  description = "Environment"
}


variable "vpc_zone_identifier" {
  description = "A list of subnets"
  type        = list(string)
  default     = null
}

variable "security_groups" {
  description = "Security group for AWS Launch Configuration"
  type        = list(string)
  default     = []
}

# Variable for VPC ID
variable "vpc_id" {
  description = "VPC id"
  type        = string
  default     = null
}

# Variable for Target Group
variable "lb_target_group_arn" {
  description = "LB Target Group ARN"
  type        = string
  default     = null
}

# Variable for SSH Key 
variable "public_key" {
  description = "SSH Key"
  type        = string
  default     = null
}

variable "desired_size" {
  type        = number
  description = "size for ASG"
}

