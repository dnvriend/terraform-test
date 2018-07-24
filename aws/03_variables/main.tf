provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "example" {
  ami = "ami-2a7d75c0" // Ubuntu Server 16.04 LTS (HVM), SSD Volume Type
  instance_type = "t2.micro"
  // interpolation syntax for looking up an attribute of a resource:
  // ${TYPE.NAME.ATTRIBUTE}
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]

  // <<-EOF .. EOF is 'heredoc' syntax which allows you to create multiline strings
  user_data = <<-EOF
      #!/bin/bash
      echo "Hello World!" > index.html
      nohup busybox httpd -f -p "${var.server_port}" &
      EOF

  tags {
    Name = "terraform-example"
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port = "${var.server_port}"
    to_port = "${var.server_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
