output "API_Gateway_URL" {
  value = module.apigateway.api_invoke_url
  description = "URL for the API Gateway"
}

output "Database_Table_Name" {
  value = module.dynamodb.dynamo_table_name
  description = "Name of the DynamoDB table"
}