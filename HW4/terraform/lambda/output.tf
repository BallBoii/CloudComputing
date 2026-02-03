output "lambda_arn" {
    value = data.aws_iam_role.lambda_exec_role.arn
    description = "The ARN of the Lambda execution role"
}

output "api_gateway_invoke_url" {
    value       = "${aws_api_gateway_stage.api_stage.invoke_url}${aws_api_gateway_resource.api_resource.path}"
    description = "Invoke URL of the API Gateway"
}