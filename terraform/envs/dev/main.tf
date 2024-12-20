terraform {
  backend "s3" {
    region = "eu-central-1"
    bucket = "terraform-e-d-m-ecomm"
    key    = "envs/dev/terraform.tfstate"
  }
}
