output "iam_role_arn" {
  description = "The ARN of the IAM role for Lambda"
  value       = aws_iam_role.iam_for_lambda.arn
}