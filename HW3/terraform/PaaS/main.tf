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

# S3 Bucket for Application Versions
resource "aws_s3_bucket" "app_versions" {
  bucket_prefix = "eb-app-versions-"
  force_destroy = true
}

# Elastic Beanstalk Application
resource "aws_elastic_beanstalk_application" "app" {
  name        = "web-application"
  description = "Web Application"
}

# Upload Application Version to S3
resource "aws_s3_object" "app_version" {
  bucket = aws_s3_bucket.app_versions.id
  key    = "${var.app_version}/myapp.zip"
  source = var.app_zip_file
  etag   = filemd5(var.app_zip_file)
}

# Elastic Beanstalk Application Version
resource "aws_elastic_beanstalk_application_version" "app_version" {
  name        = var.app_version
  application = aws_elastic_beanstalk_application.app.name
  description = "Application version ${var.app_version}"
  bucket      = aws_s3_bucket.app_versions.id
  key         = aws_s3_object.app_version.key
}

# Elastic Beanstalk Environment
resource "aws_elastic_beanstalk_environment" "web_env" {
    name                = "web-app-env"
    application         = aws_elastic_beanstalk_application.app.name
    solution_stack_name = data.aws_elastic_beanstalk_solution_stack.php.name
    version_label       = aws_elastic_beanstalk_application_version.app_version.name

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
      name      = "DBEngineVersion"
      value     = "8.0"
    }

    setting {
      namespace = "aws:rds:dbinstance"
      name      = "DBInstanceClass"
      value     = "db.t3.micro"
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
      name      = "DBName"
      value     = "appdb"
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