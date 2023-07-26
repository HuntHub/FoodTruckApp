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

variable "region" {
  description = "The region in which the resources are to be deployed"
  type        = string
}