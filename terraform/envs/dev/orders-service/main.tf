provider "aws" {
}

data "terraform_remote_state" "env" {
  backend = "local"

  config = {
    path = "../terraform.tfstate"
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
