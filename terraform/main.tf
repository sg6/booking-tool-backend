#provider.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
    region = "us-east-1"
    shared_credentials_files = ["/home/stefan/.aws/credentials-booking-app-user"]
    profile = "booking-app-user"
}