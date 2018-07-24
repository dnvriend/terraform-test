provider "aws" {
  region = "eu-west-1"
}

terraform {
  required_version = "> 0.11.6"
  backend "s3" {
    bucket = "dnvriend-terraform-state"
    key = "05_s3_remote_state/web_server/terraform.tfstate"
    region = "eu-west-1"
    encrypt = true # server side encryption
    kms_key_id = "arn:aws:kms:eu-west-1:612483924670:key/ba378940-1bec-41dc-b653-86c91740df88"
  }
}


resource "aws_instance" "example" {
  ami = "ami-2a7d75c0" // Ubuntu Server 16.04 LTS (HVM), SSD Volume Type
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]

  user_data = <<-EOF
      #!/bin/bash
      echo "Hello World!" > index.html
      nohup busybox httpd -f -p 8080 &
      EOF

  tags {
    Name = "terraform-example"
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port = 8080
    protocol = "tcp"
    to_port = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }
}