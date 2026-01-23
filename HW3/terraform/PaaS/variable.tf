variable "region" {
  description = "The region where resources will be deployed"
  type        = string
}

variable "access_key" {
  description = "AWS Access Key"
  type        = string
  sensitive   = true
}

variable "secret_key" {
  description = "AWS Secret Key"
  type        = string
  sensitive   = true
}

variable "key_pair" {
  description = "The name of the key pair to use for EC2 instances"
  type        = string
}

variable "DBUser" {
  description = "The name of admin user for RDS instance"
  type        = string
}

variable "DBPassword" {
  description = "The password for the admin user of RDS instance"
  type = string
}

variable "app_version" {
  description = "Application version label"
  type        = string
  default     = "v1"
}

variable "app_zip_file" {
  description = "Path to the application zip file"
  type        = string
  default     = "../../../myapp.zip"
}