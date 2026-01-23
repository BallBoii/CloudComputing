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
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

# Elastic Service Role
data "aws_iam_role" "elastic_beanstalk_service_role" {
  name = "aws-elasticbeanstalk-service-role"
}

# EC2 Instance Profile for Elastic Beanstalk
data "aws_iam_instance_profile" "elastic_beanstalk_instance_profile" {
  name = "aws-elasticbeanstalk-ec2-role"
}

# Key Pair
data "aws_key_pair" "keys" {
  key_name = var.key_pair
}

# Get latest PHP solution stack
data "aws_elastic_beanstalk_solution_stack" "php" {
  most_recent = true
  name_regex  = "^64bit Amazon Linux (.*) running PHP 8(.*)$"
}

# Elastic Beanstalk Application
resource "aws_elastic_beanstalk_application" "app" {
  name        = "web-application"
  description = "Web Application"
}

# Elastic Beanstalk Environment
resource "aws_elastic_beanstalk_environment" "web_env" {
    name                = "web-app-env"
    application         = aws_elastic_beanstalk_application.app.name
    solution_stack_name = data.aws_elastic_beanstalk_solution_stack.php.name

    setting {
      namespace = "aws:elasticbeanstalk:environment"
      name = "ServiceRole"
      value = data.aws_iam_role.elastic_beanstalk_service_role.arn
    }

    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name = "IamInstanceProfile"
        value = data.aws_iam_instance_profile.elastic_beanstalk_instance_profile.arn
    }
    
    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name = "EC2KeyName"
        value = data.aws_key_pair.keys.key_name
    }

    setting {
        namespace = "aws:rds:dbinstance"
        name      = "DBUser"
        value     = var.DBUser
    }

    setting {
        namespace = "aws:rds:dbinstance"
        name      = "DBPassword"
        value     = var.DBPassword
    }

    setting {
        namespace = "aws:rds:dbinstance"
        name      = "DBAllocatedStorage"
        value     = "20"
    }

    setting {
        namespace = "aws:rds:dbinstance"
        name      = "DBEngine"
        value     = "mysql"
    }
    
    setting {
        namespace = "aws:elasticbeanstalk:environment"
        name      = "EnvironmentType"
        value     = "SingleInstance"
    }
}