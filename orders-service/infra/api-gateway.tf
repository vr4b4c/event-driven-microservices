resource "aws_apigatewayv2_integration" "orders_service" {
  api_id = data.terraform_remote_state.global.outputs.ordering_platform_api_gateway_api_id

  integration_uri    = aws_lambda_function.orders_service.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "create_order" {
  api_id = data.terraform_remote_state.global.outputs.ordering_platform_api_gateway_api_id

  route_key = "POST /orders"
  target    = "integrations/${aws_apigatewayv2_integration.orders_service.id}"
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.orders_service.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${data.terraform_remote_state.global.outputs.ordering_platform_api_gateway_api_execution_arn}/*/*"
}
