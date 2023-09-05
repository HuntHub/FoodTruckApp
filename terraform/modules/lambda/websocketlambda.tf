# Lambda Function 1 - connection_manager

data "archive_file" "connection_manager_zip" {
  type        = "zip"
  source_file = "${path.root}/../lambda/connect_lambda.py"
  output_path = "${path.root}/../lambda/connect_lambda.zip"
}

resource "aws_lambda_function" "connection_manager" {
  filename         = data.archive_file.connection_manager_zip.output_path
  function_name    = "connection_manager"
  role             = var.iam_role_arn
  handler          = "connect_lambda.handler"
  source_code_hash = data.archive_file.connection_manager_zip.output_base64sha256
  runtime          = "python3.8"

  environment {
    variables = {
      tableName = var.dynamo_connection_table
    }
  }
}

# Lambda Function 2 - disconnection_manager

data "archive_file" "disconnection_manager_zip" {
  type        = "zip"
  source_file = "${path.root}/../lambda/disconnect_lambda.py"
  output_path = "${path.root}/../lambda/disconnect_lambda.zip"
}

resource "aws_lambda_function" "disconnection_manager" {
  filename         = data.archive_file.disconnection_manager_zip.output_path
  function_name    = "disconnection_manager"
  role             = var.iam_role_arn
  handler          = "disconnect_lambda.handler"
  source_code_hash = data.archive_file.disconnection_manager_zip.output_base64sha256
  runtime          = "python3.8"

  environment {
    variables = {
      tableName = var.dynamo_connection_table
    }
  }
}

# Lambda Function 3 - websocketpush

data "archive_file" "websocketpush_zip" {
  type        = "zip"
  source_file = "${path.root}/../lambda/websocketpush.py"
  output_path = "${path.root}/../lambda/websocketpush.zip"
}

resource "aws_lambda_function" "websocketpush" {
  filename         = data.archive_file.websocketpush_zip.output_path
  function_name    = "websocketpush"
  role             = var.iam_role_arn
  handler          = "websocketpush.handler"
  source_code_hash = data.archive_file.websocketpush_zip.output_base64sha256
  runtime          = "python3.8"
  timeout = 20

  environment {
    variables = {
      tableName = var.dynamo_connection_table
      websocket_url = var.websocket_url
    }
  }
}

/*
data "archive_file" "websocket_new_entry_zip" {
  type        = "zip"
  source_file = "${path.root}/../lambda/websocketnewentry.py"
  output_path = "${path.root}/../lambda/websocketnewentry.zip"
}

resource "aws_lambda_function" "websocket_new_entry" {
  filename          = data.archive_file.websocket_new_entry_zip
  function_name     = "websocket_new_entry"
  role              = var.iam_role_arn
  handler           = "websocket_new_entry.handler"
  source_code_hash  = data.archive_file.websocket_new_entry_zip.output_base64sha256
  runtime           = "python3.8"

  environment {
    variables = {
      tableName = var.dynamo_connection_table
      websocket_url = var.websocket_url
    }
  }
}
*/