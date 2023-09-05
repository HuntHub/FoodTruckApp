module "dynamodb" {
  source = "./modules/dynamodb"
  websocketpush_lambda_arn = module.lambda.lambda_function_arn_websocketpush
}

module "iam" {
  source = "./modules/iam"
}

module "lambda" {
  source = "./modules/lambda"
  iam_role_arn = module.iam.iam_role_arn
  dynamo_order_table = module.dynamodb.dynamo_order_table
  dynamo_connection_table = module.dynamodb.dynamo_connection_table
  sqs_arn = module.sqs.order_queue_arn
  sqs_url = module.sqs.order_queue_url
  WEBHOOK_SIGNATURE_KEY = var.WEBHOOK_SIGNATURE_KEY
  SQUARE_API_TOKEN = var.SQUARE_API_TOKEN
  websocket_url = var.websocket_url
}

module "sns" {
  source = "./modules/sns"
}

module "apigateway" {
  source = "./modules/apigateway"
  lambda_function_arn_webhook_handler = module.lambda.lambda_function_arn_webhook_handler
  lambda_function_name_webhook_handler = module.lambda.lambda_function_name_webhook_handler
  lambda_function_arn_order_updater = module.lambda.lambda_function_arn_order_updater
  lambda_function_name_order_updater = module.lambda.lambda_function_name_order_updater
  lambda_function_name_connection_manager = module.lambda.lambda_function_name_connection_manager
  lambda_function_name_disconnection_manager = module.lambda.lambda_function_name_disconnection_manager
  lambda_function_name_websocketpush = module.lambda.lambda_function_name_websocketpush
  lambda_function_arn_connection_manager = module.lambda.lambda_function_arn_connection_manager
  lambda_function_arn_disconnection_manager = module.lambda.lambda_function_arn_disconnection_manager
  lambda_function_arn_websocketpush = module.lambda.lambda_function_arn_websocketpush
  region = var.region
}

module "ses" {
  source       = "./modules/ses"
}

module "sqs" {
  source = "./modules/sqs"
}