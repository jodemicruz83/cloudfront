terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region  = us-east-1
  profile = "default"

  # default_tags {
  #   tags = {
  #     Environment = var.lifecycle_environment
  #     app         = var.application_name
  #   }
  # }
}