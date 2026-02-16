variable "region" {
  description = "The AWS region to create resources in"
  type        = string
}

variable "access_key" {
  description = "The AWS access key"
  type        = string
}

variable "secret_key" {
  description = "The AWS secret key"
  type        = string
}

variable "cidr_block" {
    description = "CIDR block for VPC"
    type        = string
    default = "10.0.0.0/16"
}

variable "availability_zones" {
    description = "List of availability zones for subnets"
    type        = list(string)
    default     = ["ap-southeast-2a"]
  
}

variable "name_prefix" {
    description = "Prefix for resource names"
    type        = string
    default     = "wordpress"
}