terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

resource "random_string" "bucket-name" {
  length = 16
  lower = true
  upper = false
  special = false
}

# Bucket Name
locals {
  bucket-name = "${random_string.bucket-name.result}-wide-open-bucket-terraform"
}

resource "aws_s3_bucket" "b" {
  bucket = "${local.bucket-name}-${count.index}"
  acl    = "public-read"

  count = 50
}
