data "terraform_remote_state" "global" {
  backend = "local"

  config = {
    path = "../../infra/terraform.tfstate"
  }
}
