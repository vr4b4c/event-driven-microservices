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

resource "aws_api_gateway_rest_api" "ordering_platform_api" {
  name = "ordering-platform-api"
}

resource "aws_api_gateway_resource" "ordering_platform_api" {
  parent_id   = aws_api_gateway_rest_api.ordering_platform_api.root_resource_id
  path_part   = "orders"
  rest_api_id = aws_api_gateway_rest_api.ordering_platform_api.id
}

resource "aws_api_gateway_method" "ordering_platform_api" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.ordering_platform_api.id
  rest_api_id   = aws_api_gateway_rest_api.ordering_platform_api.id
}

resource "aws_api_gateway_integration" "ordering_platform_api" {
  http_method             = aws_api_gateway_method.ordering_platform_api.http_method
  integration_http_method = aws_api_gateway_method.ordering_platform_api.http_method
  resource_id             = aws_api_gateway_resource.ordering_platform_api.id
  rest_api_id             = ws_api_gateway_rest_api.ordering_platform_api.id
  type                    = "AWS"
  uri                     = aws_lambda_function.orders_service.invoke_arn
}

resource "aws_api_gateway_deployment" "ordering_platform_api" {
  rest_api_id = aws_api_gateway_rest_api.ordering_platform_api.id

  triggers = {
    # NOTE: The configuration below will satisfy ordering considerations,
    #       but not pick up all future REST API changes. More advanced patterns
    #       are possible, such as using the filesha1() function against the
    #       Terraform configuration file(s) or removing the .id references to
    #       calculate a hash against whole resources. Be aware that using whole
    #       resources will show a difference after the initial implementation.
    #       It will stabilize to only change when resources change afterwards.
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.ordering_platform_api.id,
      aws_api_gateway_method.ordering_platform_api.id,
      aws_api_gateway_integration.ordering_platform_api.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "ordering_platform_api" {
  deployment_id = aws_api_gateway_deployment.ordering_platform_api.id
  rest_api_id   = aws_api_gateway_rest_api.ordering_platform_api.id
  stage_name    = "dev"
  #access_log_settings {
  #  destination_arn = aws_cloudwatch_log_group.ordering_platform_api.arn
  #  format          = "JSON"
  #}
  # depends_on = [aws_cloudwatch_log_group.ordering_platform_api, aws_api_gateway_account.ordering_platform_api]
}

#resource "aws_cloudwatch_log_group" "ordering_platform_api" {
#  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.ordering_platform_api.id}/dev"
#  retention_in_days = 1
#}

#resource "aws_api_gateway_account" "ordering_platform_api" {
#  cloudwatch_role_arn = aws_iam_role.api_gateway_cloudwatch.arn
#}
#
#data "aws_iam_policy_document" "api_gateway_cloudwatch" {
#  statement {
#    effect = "Allow"
#
#    principals {
#      type        = "Service"
#      identifiers = ["apigateway.amazonaws.com"]
#    }
#
#    actions = ["sts:AssumeRole"]
#  }
#}
#
#resource "aws_iam_role" "api_gateway_cloudwatch" {
#  name               = "api_gateway_cloudwatch_global"
#  assume_role_policy = data.aws_iam_policy_document.api_gateway_cloudwatch.json
#}
#
#data "aws_iam_policy_document" "cloudwatch" {
#  statement {
#    effect = "Allow"
#
#    actions = [
#      "logs:CreateLogGroup",
#      "logs:CreateLogStream",
#      "logs:DescribeLogGroups",
#      "logs:DescribeLogStreams",
#      "logs:PutLogEvents",
#      "logs:GetLogEvents",
#      "logs:FilterLogEvents",
#    ]
#
#    resources = ["*"]
#  }
#}
#resource "aws_iam_role_policy" "api_gateway_cloudwatch" {
#  name   = "default"
#  role   = aws_iam_role.api_gateway_cloudwatch.id
#  policy = data.aws_iam_policy_document.api_gateway_cloudwatch.json
#}
