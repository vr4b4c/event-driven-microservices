variable "region" {
  default = "eu-central-1"
}

variable "env" {
  default = "production"
}

variable "app_archive_s3_key" {
  default = "orders-service.zip"
}

variable "app_archive_path" {
  default = "dist/orders-service.zip"
}

variable "dynamo_table_name" {
  default = "orders"
}
