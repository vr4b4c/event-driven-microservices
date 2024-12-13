provider "aws" {
  profile = "private-dev"
}

data "aws_iam_policy_document" "assume_orders_service" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "orders_service" {
  name               = "orders-service"
  assume_role_policy = data.aws_iam_policy_document.assume_orders_service.json
}

resource "aws_iam_policy" "orders_service" {
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

resource "aws_iam_role_policy_attachment" "attach_orders_service" {
  role       = aws_iam_role.orders_service.name
  policy_arn = aws_iam_policy.orders_service.arn
}

data "archive_file" "dist" {
  type        = "zip"
  source_dir  = "${path.module}/../src/"
  output_path = "${path.module}/../dist/function.zip"
}

resource "aws_lambda_function" "orders_service" {
  filename         = "${path.module}/../dist/function.zip"
  function_name    = "orders-service"
  role             = aws_iam_role.orders_service.arn
  source_code_hash = data.archive_file.dist.output_base64sha256
  handler          = "function.Function.perform"
  runtime          = "ruby3.3"
  depends_on       = [aws_iam_role_policy_attachment.attach_orders_service]

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
