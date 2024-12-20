terraform {
  backend "s3" {
    region = "eu-central-1"
    bucket = "terraform-e-d-m-ecomm"
    key    = "envs/dev/reserve-inventory/terraform.tfstate"
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

module "reserve-inventory" {
  source = "../../../modules/reserve-inventory"

  env                     = "dev"
  region                  = "eu-central-1"
  s3_bucket_id            = data.terraform_remote_state.env.outputs.ordering_platform_api_s3_bucket_id
  order_created_queue_arn = data.terraform_remote_state.env.outputs.ordering_platform_api_order_created_queue_arn
}
