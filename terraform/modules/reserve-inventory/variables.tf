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
  default     = "reserve-inventory.zip"
}

variable "app_archive_path" {
  description = "App archive path"
  type        = string
  default     = "dist/reserve-inventory.zip"
}

variable "s3_bucket_id" {
  description = "S3 bucket id"
  type        = string
}

variable "order_created_queue_arn" {
  description = "OrderCreated SQS queue ARN"
  type        = string

}
