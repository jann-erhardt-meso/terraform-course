provider "aws" {
  region = "eu-central-1"
  profile = "DataPracticePower"
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.66.0"
    }
  }
}

resource "aws_s3_bucket" "example" {
  bucket_prefix = "my-tf-test-bucket-"
  force_destroy = true
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
