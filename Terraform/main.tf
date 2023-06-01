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
}

module "sns" {
  source = "./modules/sns"
}
