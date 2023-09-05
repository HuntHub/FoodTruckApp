variable "lambda_function_arn_webhook_handler" {
  description = "The ARN of the Lambda function to be triggered"
  type        = string
}

variable "lambda_function_name_webhook_handler" {
  description = "The name of the Lambda function to be triggered"
  type        = string
}

variable "lambda_function_arn_order_updater" {
  description = "The ARN of the order updater function"
  type        = string
}

variable "lambda_function_name_order_updater" {
  description = "The name of the order updater function"
  type        = string
}

variable "lambda_function_arn_connection_manager" {
  description = "The ARN of the connection manager function"
  type        = string
}

variable "lambda_function_arn_disconnection_manager" {
  description = "The ARN of the disconnection manager function"
  type        = string
}

variable "lambda_function_arn_websocketpush" {
  description = "The ARN of the websocketpush function"
  type        = string
}

variable "lambda_function_name_connection_manager" {
  description = "The name of the connection manager"
  type        = string
}

variable "lambda_function_name_disconnection_manager" {
  description = "The name of the disconnection manager"
  type        = string
}

variable "lambda_function_name_websocketpush" {
  description = "The name of the websocketpush function"
  type        = string
}

variable "region" {
  description = "The region in which the resources are to be deployed"
  type        = string
}