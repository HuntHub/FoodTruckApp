output "api_invoke_url" {
  description = "The URL to invoke the API Gateway"
  value       = "${aws_api_gateway_deployment.deployment.invoke_url}/${aws_api_gateway_resource.resource.path}"
}
