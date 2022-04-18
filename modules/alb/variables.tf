# Default tags
variable "default_tags" {
  default     = {}
  type        = map(any)
  description = "Default tags for AWS resources"
}

variable "env" {
  type        = string
  description = "Environment"
}

variable "subnets" {
  description = "subnets"
  type        = list(string)
  default     = null
}

# Name prefix
variable "prefix" {
  type        = string
  description = "prefix"
}



variable "security_groups" {
  description = "Load balancer sg"
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  description = "VPC id"
  type        = string
  default     = null
}