module "dynamodb" {
  source = "./modules/dynamodb"
}

module "iam" {
  source = "./modules/iam"
}

module "lambda" {
  source = "./modules/lambda"
  iam_role_arn = module.iam.iam_role_arn
  dynamo_table_name = module.dynamodb.dynamo_table_name
  sqs_arn = module.sqs.order_queue_arn
  sqs_url = module.sqs.order_queue_url
  WEBHOOK_SIGNATURE_KEY = var.WEBHOOK_SIGNATURE_KEY
  SQUARE_API_TOKEN = var.SQUARE_API_TOKEN
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
  region = var.region
}

module "ses" {
  source       = "./modules/ses"
}

module "sqs" {
  source = "./modules/sqs"
}