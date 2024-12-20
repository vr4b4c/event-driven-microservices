terraform {
  backend "s3" {
    region         = "eu-central-1"
    bucket         = "terraform-e-d-m-ecomm"
    key            = "envs/dev/orders-service/terraform.tfstate"
    dynamodb_table = "terraform-e-d-m-ecomm"
  }
}

data "terraform_remote_state" "env" {
  backend = "s3"

  config = {
    region = "eu-central-1"
    bucket = "terraform-e-d-m-ecomm"
    key    = "envs/dev/terraform.tfstate"
  }
}

module "orders-service" {
  source = "../../../modules/orders-service"

  env                           = "dev"
  region                        = "eu-central-1"
  api_gateway_api_id            = data.terraform_remote_state.env.outputs.ordering_platform_api_gateway_api_id
  api_gateway_api_execution_arn = data.terraform_remote_state.env.outputs.ordering_platform_api_gateway_api_execution_arn
  s3_bucket_id                  = data.terraform_remote_state.env.outputs.ordering_platform_api_s3_bucket_id
  order_created_queue_id        = data.terraform_remote_state.env.outputs.ordering_platform_api_order_created_queue_id

}
