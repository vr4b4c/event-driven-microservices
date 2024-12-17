variable "region" {
  default = "eu-central-1"
}

variable "env" {
  default = "production"
}

variable "app_archive_s3_key" {
  default = "reserve-inventory.zip"
}

variable "app_archive_path" {
  default = "dist/reserve-inventory.zip"
}

variable "dynamo_table_name" {
  default = "inventory"
}
