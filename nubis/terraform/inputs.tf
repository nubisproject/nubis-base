# nubis-base
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "iam_instance_profile" {}

variable "consul" {
  description = "URL to Consul"
  default = "127.0.0.1"
}

variable "secret" {
  description = "Security shared secret for consul membership (consul keygen)"
}

variable "region" {
  default = "us-east-1"
  description = "The region of AWS, for AMI lookups."
}

variable "release" {
  default = "0.84"
  description = "Release number of the architecture"
}

variable "project" {
  default = "base"
  description = "Name of the project"
}

variable "key_name" {
  description = "SSH key name in your AWS account for AWS instances."
}

