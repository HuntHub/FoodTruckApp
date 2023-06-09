# Lambda Function 1 - webhook_handler

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
      tableName = var.dynamo_table_name
    }
  }
}

# Lambda Function 2 - order_status_updater

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