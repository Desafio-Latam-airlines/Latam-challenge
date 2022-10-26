# Input variable definitions

variable "aws_region" {
  description = "AWS region to deploy resources."

  type    = string
  default = "us-east-1"
}

variable "AWS_ACCESS_KEY" {
  description = "AWS access key or public key"

  type = string
}

variable "AWS_SECRET_KEY" {
  description = "AWS secret key or secret key"

  type = string
}