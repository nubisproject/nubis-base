output "ami" {
  value = "${consul_keys.app.var.ami}"
}

output "instance-id" {
  value = "${aws_instance.node.id}"
}

output "instance" {
  value = "${aws_instance.node.public_dns}"
}
