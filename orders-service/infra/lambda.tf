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
  name               = "orders_service"
  assume_role_policy = data.aws_iam_policy_document.orders_service.json
}

resource "aws_iam_role_policy_attachment" "orders_service" {
  role       = aws_iam_role.orders_service.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "orders_service" {
  function_name    = "orders_service"
  s3_bucket        = data.terraform_remote_state.global.outputs.ordering_platform_api_s3_bucket_id
  s3_key           =  var.app_archive_s3_key 
  runtime          = "ruby3.3"
  handler          = "function.Function.perform"
  source_code_hash = filebase64sha256("../${var.app_archive_path}")
  role             = aws_iam_role.orders_service.arn

  environment {
    variables = {
      ORDERS_SERVICE_APP_ENV           = var.env
      ORDERS_SERVICE_DYNAMO_TABLE_NAME = aws_dynamodb_table.orders.name
      ORDERS_SERVICE_DYNAMO_REGION     = var.region
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
    actions   = ["dynamodb:*"]
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