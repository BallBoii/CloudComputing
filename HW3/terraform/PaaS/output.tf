# Application Outputs
output "application_name" {
  description = "Name of the Elastic Beanstalk application"
  value       = aws_elastic_beanstalk_application.app.name
}

# Environment Outputs
output "environment_name" {
  description = "Name of the Elastic Beanstalk environment"
  value       = aws_elastic_beanstalk_environment.web_env.name
}

output "environment_id" {
  description = "ID of the Elastic Beanstalk environment"
  value       = aws_elastic_beanstalk_environment.web_env.id
}

output "environment_endpoint" {
  description = "Fully qualified DNS name for the environment"
  value       = aws_elastic_beanstalk_environment.web_env.endpoint_url
}

output "environment_cname" {
  description = "CNAME for the environment"
  value       = aws_elastic_beanstalk_environment.web_env.cname
}

output "environment_url" {
  description = "URL to access the application"
  value       = "http://${aws_elastic_beanstalk_environment.web_env.cname}"
}

# Configuration Outputs
output "solution_stack" {
  description = "Solution stack used by the environment"
  value       = aws_elastic_beanstalk_environment.web_env.solution_stack_name
}

output "region" {
  description = "AWS region where resources are deployed"
  value       = var.region
}

# Database Connection Information
output "database_endpoint" {
  description = "RDS database endpoint (available after environment is created)"
  value       = aws_elastic_beanstalk_environment.web_env.endpoint_url
}