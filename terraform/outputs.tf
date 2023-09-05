output "API_Create_Order_Endpoint" {
  value = module.apigateway.api_invoke_url
  description = "URL for the API Gateway"
}

output "DB_Order_Database_Name" {
  value = module.dynamodb.dynamo_order_table
  description = "Name of the table that stores the order IDs"
}

output "DB_Connection_Database_Name" {
  value = module.dynamodb.dynamo_connection_table
  description = "Name of the table that stores the connection IDs"
}

output "API_WebSocket_Endpoint" {
  value = module.apigateway.websocket_api_endpoint_url
  description = "Endpoint for the WebSocket API"
}