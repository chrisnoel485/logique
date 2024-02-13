provider "aws" {
  # profile = "chrisnoel"
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "terraform-backend-log-bucket"
    key = "testing/logique.tf"
    region = "ap-southeast-1"
  }
}