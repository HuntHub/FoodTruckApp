resource "aws_dynamodb_table" "orders_table" {
  name           = "OrdersTable"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "order_id"

  stream_enabled = true
  stream_view_type = "KEYS_ONLY"

  attribute {
    name = "order_id"
    type = "S"
  }
}

resource "aws_lambda_event_source_mapping" "order_mapping" {
  event_source_arn = aws_dynamodb_table.orders_table.stream_arn
  function_name    = var.websocketpush_lambda_arn
  starting_position = "LATEST"
}

resource "aws_dynamodb_table" "websocket_connections" {
  name           = "WebSocketConnections"  # name of the DynamoDB table
  billing_mode   = "PAY_PER_REQUEST"  # use on-demand pricing, change if necessary
  hash_key       = "connectionId"  # primary key

  attribute {
    name = "connectionId"
    type = "S"
  }

  # Optionally add server-side encryption
  server_side_encryption {
    enabled = true
  }

  # Optionally enable point-in-time recovery
  point_in_time_recovery {
    enabled = false
  }

  # Optionally set Time To Live (TTL) for the items
  /*
  ttl {
    attribute_name = "expirationTime"
    enabled        = false  # Set to true if you want to utilize TTL with expirationTime attribute
  }
  */
  
  # Optionally add tags to the table
  tags = {
    Name        = "WebSocketConnections"
    Environment = "Production"  # Adjust as per your requirements
  }
}
