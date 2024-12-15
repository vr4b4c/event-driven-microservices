terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.81.0"
    }
  }

  required_version = "~> 1.0"
}

provider "aws" {
  profile = "private-dev"
  region = var.region
}
