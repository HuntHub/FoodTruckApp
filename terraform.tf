/*provider "aws" {
  region = "us-east-1"
}

# Create IAM role for Lambda function
resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"
  
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_role_policy" {
  name = "lambda_role_policy"
  role = aws_iam_role.lambda_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:PutItem",
        "dynamodb:UpdateItem",
        "dynamodb:GetItem",
        "sns:Publish"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

# Create DynamoDB table
resource "aws_dynamodb_table" "orders" {
  name = "Orders"
  billing_mode = "PROVISIONED"
  read_capacity = 20
  write_capacity = 20
  hash_key = "order_id"

  attribute {
    name = "order_id"
    type = "S"
  }
}

# Create SNS topic
resource "aws_sns_topic" "order_updates" {
  name = "OrderUpdates"
}


# Create Lambda functions
resource "aws_lambda_function" "webhook_handler" {
  filename      = "your_lambda_function_path/webhook_handler.zip"
  function_name = "webhook_handler"
  role          = aws_iam_role.lambda_role.arn
  handler       = "webhook_handler.lambda_handler"
  runtime       = "python3.9"
}

resource "aws_lambda_function" "order_status_updater" {
  filename      = "your_lambda_function_path/order_status_updater.zip"
  function_name = "order_status_updater"
  role          = aws_iam_role.lambda_role.arn
  handler       = "order_status_updater.lambda_handler"
  runtime       = "python3.9"

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.order_updates.arn
    }
  }
}
*/