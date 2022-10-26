# version of providers used for the project
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }

  required_version = "~> 1.0"
}

# Declare variable name for aws provider
provider "aws" {
  region     = var.aws_region
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
}

# Create S3 bucket
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "latam_bucket"
}

# Declare S3 ACL type
resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.lambda_bucket.id
  acl    = "private"
}

# Compress lambda directory into a zip file
data "archive_file" "lambda_pickle_model" {
  type = "zip"

  source_dir  = "${path.module}/pickle_model"
  output_path = "${path.module}/pickle_model.zip"
}

# Upload the lambda file to S3
resource "aws_s3_object" "lambda_pickle_model" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "pickle_model.zip"
  source = data.archive_file.lambda_pickle_model.output_path

  etag = filemd5(data.archive_file.lambda_pickle_model.output_path)
}

# Upload serialized model to S3
resource "aws_s3_object" "serialized_model" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "pickle_model.pkl"
  source = "${path.module}/pickle_model.pkl"

  etag = filemd5("${path.module}/pickle_model.pkl")
}