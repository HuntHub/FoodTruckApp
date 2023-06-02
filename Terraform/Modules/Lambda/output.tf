output "lambda_function_arn_webhook_handler" {
  description = "The ARN of the webhook_handler Lambda function"
  value       = aws_lambda_function.webhook_handler.arn
}

output "lambda_function_name_webhook_handler" {
  description = "The name of the webhook_handler Lambda function"
  value       = aws_lambda_function.webhook_handler.function_name
}
