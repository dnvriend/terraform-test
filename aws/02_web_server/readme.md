# 02_web_server
Provision a web server that responds with 'hello world' at port 8080

## Deploying the infrastructure
First the directory has to be initialized. This can be done via the `terraform init` command, which initializes 
the workdir with the `.terraform` directory that contains the `plugins` which will contain a provider that has
been configured.

```hcl-terraform
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
```

We will provision a `t2.micro` with an Ubuntu AMI and configure the server with a script that has been set via 
the `user_data` attribute. We also provision a `security-group` so that port 8080 is accessible. The server will be
deployed to the default VPC that only has public subnets. Use the `plan`, `apply`, `show` and `destroy` commands.



