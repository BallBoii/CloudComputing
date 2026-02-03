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

variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "ap-southeast-1"
}

variable "lambda_role_name" {
  description = "Name of the existing IAM role for Lambda execution"
  type        = string
}