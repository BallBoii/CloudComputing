# Provider Configuration
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configuration the AWS Provider
provider "aws" {
  region = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

# Data source for latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-6.1-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# EC2 Instance Resource
resource "aws_instance" "siege_server" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type
  key_name      = var.key_pair
  subnet_id     = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.allow_http_ssh.id]

  tags = {
    Name = "Siege-Server"
  }
}

resource "aws_instance" "web_server" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type
  key_name      = var.key_pair
  subnet_id     = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.allow_http_ssh.id]

  tags = {
    Name = "Web-Server"
  }
}

resource "aws_instance" "sql_server" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type
  key_name      = var.key_pair
  subnet_id     = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.allow_http_ssh.id]

  tags = {
    Name = "SQL-Server"
  }
}

resource "aws_instance" "ansible_server" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type
  key_name      = var.key_pair
  subnet_id     = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.allow_http_ssh.id]
  
  # add git
  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y git
              EOF

  tags = {
    Name = "Ansible-Server"
  }
}

# Get default VPC
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Security Group Resource
resource "aws_security_group" "allow_http_ssh" {
  name        = "allow_http_ssh"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "MySQL/MariaDB"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http_ssh"
  }

}