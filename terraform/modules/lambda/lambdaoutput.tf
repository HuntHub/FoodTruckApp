output "lambda_function_arn_webhook_handler" {
  description = "The ARN of the webhook_handler Lambda function"
  value       = aws_lambda_function.webhook_handler.arn
}

output "lambda_function_name_webhook_handler" {
  description = "The name of the webhook_handler Lambda function"
  value       = aws_lambda_function.webhook_handler.function_name
}

output "lambda_function_arn_order_updater" {
  description = "The ARN of the order updater"
  value = aws_lambda_function.order_status_updater.arn
}

output "lambda_function_name_order_updater" {
  description = "The name of the order updater function"
  value = aws_lambda_function.order_status_updater.function_name 
}

output "lambda_function_arn_connection_manager" { 
  description = "The ARN of the connection manager function"
  value = aws_lambda_function.connection_manager.arn
}

output "lambda_function_name_connection_manager" {
  description = "The name of the connection manager function"
  value = aws_lambda_function.connection_manager.function_name
}

output "lambda_function_arn_disconnection_manager" {
  description = "The ARN of the disconnection manager function"
  value = aws_lambda_function.disconnection_manager.arn
}

output "lambda_function_name_disconnection_manager" {
  description = "The name of the disconnection manager function"
  value = aws_lambda_function.disconnection_manager.function_name
}

output "lambda_function_arn_websocketpush" {
  description = "The ARN of the websocket push function"
  value = aws_lambda_function.websocketpush.arn
}

output "lambda_function_name_websocketpush" {
  description = "The name of the websocket push function"
  value = aws_lambda_function.websocketpush.function_name
}
/*
output "lambda_function_arn_websocket_new_entry" {
  description = "The ARN of the websocket new entry function"
  value = aws_lambda_function.websocket_new_entry.arn
}

output "lambda_function_name_websocket_new_entry" {
  description = "The name of the websocket new entry function"
  value = aws_lambda_function.websocket_new_entry.function_name
}
*/