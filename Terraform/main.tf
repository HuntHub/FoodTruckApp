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
  SQUARE_API_TOKEN = "EAAAEP55lWQwSc-rSQS41rzwSKKCZIyJ2I1GitMw49ZA0jvNc6wbsX5eHq8luQi0"
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
}

module "ses" {
  source       = "./modules/ses"
}

module "sqs" {
  source = "./modules/sqs"
}