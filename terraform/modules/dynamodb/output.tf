output "dynamo_order_table" {
  description = "The name of the DynamoDB table that stores the order IDs"
  value       = aws_dynamodb_table.orders_table.name
}

output "dynamo_connection_table" {
  description = "The name of the DynamoDB table that stores the connection IDs"
  value = aws_dynamodb_table.websocket_connections.name
}