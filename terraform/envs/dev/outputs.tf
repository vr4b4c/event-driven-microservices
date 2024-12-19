output "ordering_platform_api_s3_bucket_id" {
  value = aws_s3_bucket.ordering_platform_api.id
}
output "ordering_platform_api_gateway_api_id" {
  value = aws_apigatewayv2_api.ordering_platform_api.id
}

output "ordering_platform_api_gateway_api_execution_arn" {
  value = aws_apigatewayv2_api.ordering_platform_api.execution_arn
}

output "api_base_url" {
  value = aws_apigatewayv2_stage.dev.invoke_url
}

output "ordering_platform_api_order_created_queue_id" {
  value = aws_sqs_queue.order_created.id
}

output "ordering_platform_api_order_created_queue_arn" {
  value = aws_sqs_queue.order_created.arn
}
