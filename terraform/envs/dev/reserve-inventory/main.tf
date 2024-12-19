provider "aws" {
}

data "terraform_remote_state" "env" {
  backend = "local"

  config = {
    path = "../terraform.tfstate"
  }
}

module "reserve-inventory" {
  source = "../../../modules/reserve-inventory"

  env                     = "dev"
  region                  = "eu-central-1"
  s3_bucket_id            = data.terraform_remote_state.env.outputs.ordering_platform_api_s3_bucket_id
  order_created_queue_arn = data.terraform_remote_state.env.outputs.ordering_platform_api_order_created_queue_arn
}
