variable "region" {
  description = "AWS region"
  type        = string
}

variable "env" {
  description = "Infrastructure environment"
  type        = string
}

variable "app_archive_s3_key" {
  description = "App archive S3 key"
  type        = string
  default     = "orders-service.zip"
}

variable "app_archive_path" {
  description = "App archive path"
  type        = string
  default     = "dist/orders-service.zip"
}

variable "dynamo_table_name" {
  description = "DynamoDB table name"
  type        = string
  default     = "orders"
}

variable "api_gateway_api_id" {
  description = "API Gateway API id"
  type        = string
}

variable "api_gateway_api_execution_arn" {
  description = "API Gateway API execution ARN"
  type        = string

}

variable "s3_bucket_id" {
  description = "S3 bucket id"
  type        = string
}

variable "order_created_queue_id" {
  description = "OrderCreated SQS queue id"
  type        = string

}
