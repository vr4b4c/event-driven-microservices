provider "aws" {
  profile = "private-dev"
}

data "aws_iam_policy_document" "assume_lambda_demo" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_demo" {
  name               = "lambda_demo"
  assume_role_policy = data.aws_iam_policy_document.assume_lambda_demo.json
}

resource "aws_iam_policy" "lambda_demo" {
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"],
      Resource = "arn:aws:logs:*:*:*",
      Effect   = "Allow"
      }, {
      Action   = ["dynamodb:PutItem"],
      Resource = "arn:aws:dynamodb:*:*:*",
      Effect   = "Allow"
      }
    ],
  })
}

resource "aws_iam_role_policy_attachment" "attach_lambda_demo_role_to_policy" {
  role       = aws_iam_role.lambda_demo.name
  policy_arn = aws_iam_policy.lambda_demo.arn
}

data "archive_file" "dist" {
  type        = "zip"
  source_dir  = "${path.module}/../src/"
  output_path = "${path.module}/../dist/function.zip"
}

resource "aws_lambda_function" "lambda_demo" {
  filename         = "${path.module}/../dist/function.zip"
  function_name    = "lambda_demo"
  role             = aws_iam_role.lambda_demo.arn
  source_code_hash = data.archive_file.dist.output_base64sha256
  handler          = "function.Function.perform"
  runtime          = "ruby3.3"
  depends_on       = [aws_iam_role_policy_attachment.attach_lambda_demo_role_to_policy]

  environment {
    variables = {
      ORDERS_SERVICE_APP_ENV           = "production"
      ORDERS_SERVICE_DYNAMO_TABLE_NAME = "orders"
      ORDERS_SERVICE_DYNAMO_REGION     = "eu-north-1"
    }
  }
}

resource "aws_dynamodb_table" "orders" {
  name           = "orders"
  hash_key       = "order_id"
  read_capacity  = 1
  write_capacity = 1

  attribute {
    name = "order_id"
    type = "S"
  }
}
