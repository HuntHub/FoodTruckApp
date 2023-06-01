output "dynamo_table_name" {
  description = "The name of the DynamoDB table"
  value       = aws_dynamodb_table.orders_table.name
}