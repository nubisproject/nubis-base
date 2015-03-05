# Configure the AWS Provider
provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.region}"
}

provider "consul" {
    address = "${var.consul}:8500"
    datacenter = "${var.region}"
}

resource "consul_keys" "app" {
    # Read the current base release
    key {
        name = "current"
	path = "nubis/base/releases/current"
    }
    
    # Read the launch AMI from Consul
    key {
        name = "ami"
        path = "nubis/${var.project}/releases/${var.release}.${var.build}/${var.region}"
    }
}

resource "aws_security_group" "simple" {
  name = "simple-ssh"
  description = "Allow SSH"
  
  // These are for internal traffic
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "consul" {
  name = "simple-consul"
  description = "Allow Consul"

  ingress {
    from_port = 8300
    to_port = 8302
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8300
    to_port = 8302
    protocol = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "node" {
  ami = "${consul_keys.app.var.ami}"
  
  instance_type = "m3.medium"
  key_name = "${var.key_name}"
  
  security_groups = [
    "${aws_security_group.simple.name}",
    "${aws_security_group.consul.name}"
  ]
  
  tags {
        Name = "Consul base (v/${var.release}.${var.build})"
        Release = "${var.release}.${var.build}"
  }

  user_data = "CONSUL_PUBLIC=1\nCONSUL_DC=${var.region}\nCONSUL_SECRET=${var.consul_secret}\nCONSUL_JOIN=${var.consul}\nCONSUL_KEY=\"${file("${var.ssl_key}")}\"\nCONSUL_CERT=\"${file("${var.ssl_cert}")}\""
}
