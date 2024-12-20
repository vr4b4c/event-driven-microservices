data "aws_iam_policy_document" "orders_service" {
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
  assume_role_policy = data.aws_iam_policy_document.orders_service.json
}

resource "aws_iam_role_policy_attachment" "orders_service" {
  role       = aws_iam_role.orders_service.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "orders_service" {
  function_name    = "orders-service"
  s3_bucket        = var.s3_bucket_id
  s3_key           = var.app_archive_s3_key
  runtime          = "ruby3.3"
  handler          = "function.Function.perform"
  source_code_hash = filebase64sha256("${path.module}/../../../orders-service/${var.app_archive_path}")
  role             = aws_iam_role.orders_service.arn

  environment {
    variables = {
      APP_ENV                    = var.env
      DYNAMO_TABLE_NAME          = aws_dynamodb_table.orders.name
      DYNAMO_REGION              = var.region
      ORDER_CREATED_QUEUE_REGION = var.region
      ORDER_CREATED_QUEUE_URL    = var.order_created_queue_id

    }
  }
}

resource "aws_cloudwatch_log_group" "orders_service" {
  name              = "/aws/lambda/${aws_lambda_function.orders_service.function_name}"
  retention_in_days = 1
}

data "aws_iam_policy_document" "orders_service_others" {
  statement {
    effect    = "Allow"
    actions   = ["dynamodb:*", "sqs:*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "orders_service_others" {
  name   = "orders-service-others"
  policy = data.aws_iam_policy_document.orders_service_others.json
}

resource "aws_iam_role_policy_attachment" "orders_service_others" {
  role       = aws_iam_role.orders_service.name
  policy_arn = aws_iam_policy.orders_service_others.arn
}
