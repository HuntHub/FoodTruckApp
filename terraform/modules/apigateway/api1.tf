resource "aws_api_gateway_rest_api" "api" {
  name = "API"
  description = "API Gateway for triggering Lambda function"
}

resource "aws_api_gateway_resource" "resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "placeorder"
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.method.http_method
  depends_on = [var.lambda_function_name_webhook_handler]
  type = "AWS_PROXY"
  uri  = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.lambda_function_arn_webhook_handler}/invocations"
  integration_http_method = "POST"
}

resource "aws_lambda_permission" "permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name_webhook_handler
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/${aws_api_gateway_method.method.http_method}${aws_api_gateway_resource.resource.path}"
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on  = [
    aws_api_gateway_integration.integration,
    aws_api_gateway_method.method,
    aws_api_gateway_resource.resource,
    var.lambda_function_name_webhook_handler,
    aws_lambda_permission.permission
  ]
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "test"
}
/*
resource "aws_api_gateway_stage" "stage1" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "test"
}
*/