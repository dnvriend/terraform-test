output "web_server_public_ip" {
  value = "${aws_instance.example.public_ip}"
}
