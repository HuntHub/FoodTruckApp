output "Create_Order_Endpoint" {
  value = module.apigateway.api_invoke_url
  description = "URL for the API Gateway"
}

output "Update_Order_Endpoint" {
  value = module.apigateway.api_invoke_url
  
}

output "Database_Table_Name" {
  value = module.dynamodb.dynamo_table_name
  description = "Name of the DynamoDB table"
}