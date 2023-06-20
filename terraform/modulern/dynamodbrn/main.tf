resource "aws_dynamodb_table" "orders_table" {
  name           = "OrdersTable"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "order_id"

  attribute {
    name = "order_id"
    type = "S"
  }
}
