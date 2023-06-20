variable "iam_role_arn" {
  description = "The ARN of the IAM role"
  type        = string
}

variable "dynamo_table_name" {
  description = "The name of the DynamoDB table"
  type        = string
}

variable "sqs_arn" {
  description = "ARN of the SQS queue"
  type        = string
}

variable "sqs_url" {
  description = "URL of the SQS queue"
  type        = string
}

variable "WEBHOOK_SIGNATURE_KEY" {
  description = "The webhook signature key for Square"
  type        = string
  sensitive   = true
}

variable "SQUARE_API_TOKEN" {
  description = "The token for the Square API"
  type        = string
  sensitive   = true
}