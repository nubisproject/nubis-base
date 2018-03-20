# nubis-base
variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "consul" {
  description = "URL to Consul"
  default     = "127.0.0.1"
}

variable "consul_secret" {
  description = "Security shared secret for consul membership (consul keygen)"
}

variable "region" {
  default     = "us-east-1"
  description = "The region of AWS, for AMI lookups."
}

variable "release" {
  default     = "0"
  description = "Release number of the architecture"
}

variable "build" {
  default     = "91"
  description = "Build number of the architecture"
}

variable "project" {
  default     = "base"
  description = "Name of the project"
}

variable "key_name" {
  description = "SSH key name in your AWS account for AWS instances."
}

variable "ssl_cert" {
  description = "SSL Certificate file"
}

variable "ssl_key" {
  description = "SSL Key file"
}
