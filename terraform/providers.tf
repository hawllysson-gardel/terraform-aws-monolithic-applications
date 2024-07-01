terraform {
  required_version = "~> 1.7.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.56.1"
    }
  }

  backend "s3" {
    bucket         = "my-bucket-s3-terraform-state"
    key            = "my-terraform-state.tfstate"
    region         = "sa-east-1"
    dynamodb_table = "my-dynamodb-terraform-state"
  }
}

provider "aws" {
  profile = "default"
  region  = var.aws_region
}