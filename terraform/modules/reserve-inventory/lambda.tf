data "aws_iam_policy_document" "reserve_inventory" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "reserve_inventory" {
  name               = "reserve_inventory"
  assume_role_policy = data.aws_iam_policy_document.reserve_inventory.json
}

resource "aws_iam_role_policy_attachment" "reserve_inventory" {
  role       = aws_iam_role.reserve_inventory.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "reserve_inventory" {
  function_name    = "reserve_inventory"
  s3_bucket        = var.s3_bucket_id
  s3_key           = var.app_archive_s3_key
  runtime          = "ruby3.3"
  handler          = "function.Function.perform"
  source_code_hash = filebase64sha256("${path.module}/../../../reserve-inventory/${var.app_archive_path}")
  role             = aws_iam_role.reserve_inventory.arn

  environment {
    variables = {
      APP_ENV       = var.env
      DYNAMO_REGION = var.region

    }
  }
}

resource "aws_cloudwatch_log_group" "reserve_inventory" {
  name              = "/aws/lambda/${aws_lambda_function.reserve_inventory.function_name}"
  retention_in_days = 1
}

data "aws_iam_policy_document" "reserve_inventory_others" {
  statement {
    effect    = "Allow"
    actions   = ["sqs:*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "reserve_inventory_others" {
  name   = "reserve-inventory-others"
  policy = data.aws_iam_policy_document.reserve_inventory_others.json
}

resource "aws_iam_role_policy_attachment" "reserve_inventory_others" {
  role       = aws_iam_role.reserve_inventory.name
  policy_arn = aws_iam_policy.reserve_inventory_others.arn
}

resource "aws_lambda_event_source_mapping" "reserve_inventory" {
  event_source_arn = var.order_created_queue_arn

  function_name = aws_lambda_function.reserve_inventory.arn
}
