resource "aws_apigatewayv2_api" "websocket_api" {
  name          = "my-websocket-api"
  protocol_type = "WEBSOCKET"
  route_selection_expression = "$request.body.action"
}

resource "aws_apigatewayv2_route" "connect_route" {
  api_id    = aws_apigatewayv2_api.websocket_api.id
  route_key = "$connect"
  target    = "integrations/${aws_apigatewayv2_integration.connect_integration.id}"
}

resource "aws_apigatewayv2_integration" "connect_integration" {
  api_id = aws_apigatewayv2_api.websocket_api.id
  integration_type = "AWS_PROXY"
  integration_uri = var.lambda_function_arn_connection_manager
}

resource "aws_apigatewayv2_route" "disconnect_route" {
  api_id    = aws_apigatewayv2_api.websocket_api.id
  route_key = "$disconnect"
  target    = "integrations/${aws_apigatewayv2_integration.disconnect_integration.id}"
}

resource "aws_apigatewayv2_integration" "disconnect_integration" {
  api_id             = aws_apigatewayv2_api.websocket_api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = var.lambda_function_arn_disconnection_manager
}

resource "aws_apigatewayv2_route" "message_route" {
  api_id    = aws_apigatewayv2_api.websocket_api.id
  route_key = "sendMessage"
  target    = "integrations/${aws_apigatewayv2_integration.message_integration.id}"
}

resource "aws_apigatewayv2_integration" "message_integration" {
  api_id             = aws_apigatewayv2_api.websocket_api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = var.lambda_function_arn_websocketpush
}

resource "aws_apigatewayv2_deployment" "websocket_deployment" {
  api_id      = aws_apigatewayv2_api.websocket_api.id
  description = "WebSocket API deployment"

  # Ensuring configurations are set up before deploying.
  depends_on = [
    aws_apigatewayv2_route.connect_route,
    aws_apigatewayv2_route.disconnect_route,
    aws_apigatewayv2_route.message_route,
    aws_apigatewayv2_integration.connect_integration,
    aws_apigatewayv2_integration.disconnect_integration,
    aws_apigatewayv2_integration.message_integration
  ]
}

resource "aws_apigatewayv2_stage" "websocket_stage" {
  api_id        = aws_apigatewayv2_api.websocket_api.id
  name          = "test"
  deployment_id = aws_apigatewayv2_deployment.websocket_deployment.id

  default_route_settings {
    logging_level = "INFO"
    data_trace_enabled = true
    detailed_metrics_enabled = true
    throttling_burst_limit = 20
    throttling_rate_limit = 10
  }
}

resource "aws_lambda_permission" "websocket_connect_permission_3" {
  statement_id  = "AllowAPIGatewayInvokeForConnect"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name_connection_manager
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.websocket_api.execution_arn}/*/${aws_apigatewayv2_route.connect_route.route_key}"
}

resource "aws_lambda_permission" "websocket_connect_permission_4" {
  statement_id  = "AllowAPIGatewayInvokeForDisconnect"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name_disconnection_manager
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.websocket_api.execution_arn}/*/${aws_apigatewayv2_route.disconnect_route.route_key}"
}

resource "aws_lambda_permission" "websocket_connect_permission_5" {
  statement_id  = "AllowAPIGatewayInvokeForMessage"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name_websocketpush
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.websocket_api.execution_arn}/*/${aws_apigatewayv2_route.message_route.route_key}"
}