# Define a second API resource
resource "aws_api_gateway_resource" "resource2" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "updateorder"
}

# Define a second API method
resource "aws_api_gateway_method" "method2" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resource2.id
  http_method   = "POST"
  authorization = "NONE"
}

# Define a second API integration
resource "aws_api_gateway_integration" "integration2" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource2.id
  http_method = aws_api_gateway_method.method2.http_method
  depends_on = [var.lambda_function_name_order_updater]
  type = "AWS_PROXY"
  uri  = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/${var.lambda_function_arn_order_updater}/invocations"
  integration_http_method = "POST"
}

# Define a second Lambda permission
resource "aws_lambda_permission" "permission2" {
  statement_id  = "AllowAPIGatewayInvoke2"
  action        = "lambda:InvokeFunction"
  function_name =  var.lambda_function_name_order_updater
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/${aws_api_gateway_method.method2.http_method}${aws_api_gateway_resource.resource2.path}"
}

# Define a second API deployment
resource "aws_api_gateway_deployment" "deployment2" {
  depends_on  = [
    aws_api_gateway_integration.integration2, 
    aws_api_gateway_method.method2,
    aws_api_gateway_resource.resource2
  ]
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "test"
}
/*
resource "aws_api_gateway_stage" "stage2" {
  deployment_id = aws_api_gateway_deployment.deployment2.id
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "test2"
}
*/