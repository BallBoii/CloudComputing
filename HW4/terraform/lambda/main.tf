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

data "aws_iam_role" "lambda_exec_role" {
  name = var.lambda_role_name
}

# Lambda Function Resource
resource "aws_lambda_function" "Lambda_calculater" {
  function_name = "calculater"
  role          = data.aws_iam_role.lambda_exec_role.arn
  handler       = "main.lambda_handler"
  runtime       = "python3.9"
  filename      = "main2.zip"
  
  source_code_hash = filebase64sha256("main2.zip")

  environment {
    variables = {
      LOG_LEVEL = "INFO"
    }
  }
}