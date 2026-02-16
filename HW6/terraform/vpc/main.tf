# VPC Module for CBME-iPDM
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configuration the AWS Provider
provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}


# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
    tags = {
        Name = "Wordpress-VPC"
    }
}


# Public Subnets
resource "aws_subnet" "public" {
  count = 1

  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.cidr_block, 4, count.index)
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${aws_vpc.main.tags["Name"]}-public-${var.availability_zones[count.index]}"
    Type = "public"
  }
}

# Private Subnets
resource "aws_subnet" "private" {
  count = 1

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.cidr_block, 4, count.index + length(var.availability_zones))
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${aws_vpc.main.tags["Name"]}-private-${var.availability_zones[count.index]}"
    Type = "private"
  }
}
