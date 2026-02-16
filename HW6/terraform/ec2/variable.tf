variable "access_key" {
  description = "The AWS access key."
  type        = string
}

variable "secret_key" {
  description = "The AWS secret key."
  type        = string
}

variable "region" {
  description = "The AWS region."
  type        = string
}

variable "instance_type" {
  description = "The type of instance to use."
  type        = string
}

variable "key_pair" {
  description = "SSH key"
  type        = string
}

variable "name_prefix" {
  description = "Prefix name"
    type        = string
}

variable "public_subnet" {
  description = "The public subnet ID."
  type        = string
}

variable "private_subnet" {
  description = "The private subnet ID."
  type        = string
}
