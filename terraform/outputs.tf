output "ami" {
  value = "${consul_keys.app.var.ami}"
}

output "instance" {
  value = "${aws_instance.node.public_dns}"
}
