# Lambda Function 1 - webhook_handler
/*
data "archive_file" "webhook_handler_zip" {
  type        = "zip"
  source_file = "${path.root}/../lambda/webhook_handler.py"
  output_path = "${path.root}/../lambda/webhook_handler.zip"
}

resource "aws_lambda_function" "webhook_handler" {
  filename      = data.archive_file.webhook_handler_zip.output_path
  function_name = "webhook_handler"
  role          = var.iam_role_arn
  handler       = "webhook_handler.handler"
  source_code_hash = data.archive_file.webhook_handler_zip.output_base64sha256
  runtime       = "python3.8"

  environment {
    variables = {
      WEBHOOK_SIGNATURE_KEY = var.WEBHOOK_SIGNATURE_KEY
      tableName = var.dynamo_table_name
      QUEUE_URL = var.sqs_url
    }
  }
}
*/
# Lambda Function 2 - customer_api_call

data "archive_file" "customer_api_call_zip" {
  type        = "zip"
  source_dir = "${path.root}/../lambda/customer_api_call"
  output_path = "${path.root}/../lambda/customer_api_call.zip"
}

resource "aws_lambda_function" "customer_api_call" {
  filename = data.archive_file.customer_api_call_zip.output_path
  function_name = "customer_api_call"
  source_code_hash = data.archive_file.customer_api_call_zip.output_base64sha256
  role = var.iam_role_arn
  handler = "customer_api_call.handler"
  runtime = "python3.8"
  timeout = 15

  environment {
    variables = {
      SQUARE_API_TOKEN = var.SQUARE_API_TOKEN
    }
  }
}

# Lambda Function 3 - order_status_updater

data "archive_file" "order_status_updater_zip" {
  type        = "zip"
  source_file = "${path.root}/../lambda/order_status_updater.py"
  output_path = "${path.root}/../lambda/order_status_updater.zip"
}

resource "aws_lambda_function" "order_status_updater" {
  filename      = data.archive_file.order_status_updater_zip.output_path
  function_name = "order_status_updater"
  role          = var.iam_role_arn
  handler       = "order_status_updater.handler"
  source_code_hash = data.archive_file.order_status_updater_zip.output_base64sha256
  runtime       = "python3.8"


  dead_letter_config {
    target_arn = var.sqs_arn
  }

  environment {
    variables = {
      tableName = var.dynamo_table_name
      DEAD_LETTER_QUEUE_URL = var.sqs_url
    }
  }
}

resource "aws_lambda_event_source_mapping" "sqs_event" {
  event_source_arn = var.sqs_arn
  function_name   = aws_lambda_function.customer_api_call.function_name
  batch_size      = 10
}