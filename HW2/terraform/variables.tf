variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "ap-southeast-1"
}

variable "instance_type" {
  description = "The type of AWS EC2 instance to use"
  type        = string
  default     = "t3.micro"
}

variable "access_key" {
  description = "The AWS access key"
  type        = string
  sensitive   = true
}

variable "secret_key" {
  description = "The AWS secret key"
  type        = string
  sensitive   = true
}

variable "key_pair" {
  description = "The name of the SSH key pair"
  type        = string
  default     = "my-key-pair"
}