variable "iam_role_arn" {
  description = "The ARN of the IAM role"
  type        = string
}

variable "dynamo_table_name" {
  description = "The name of the DynamoDB table"
  type        = string
}
