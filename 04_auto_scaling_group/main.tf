provider "aws" {
  region = "eu-west-1"
}

resource "aws_launch_configuration" "example" {
  image_id               = "ami-2a7d75c0"                        // Ubuntu Server 16.04 LTS (HVM), SSD Volume Type
  instance_type          = "t2.micro"
  security_groups = ["${aws_security_group.instance.id}"]

  user_data = <<-EOF
      #!/bin/bash
      echo "Hello World!" > index.html
      nohup busybox httpd -f -p "${var.server_port}" &
      EOF

  // lifecycle is a meta-parameter that tells terraform
  // how a resource should be created.
  lifecycle {
    create_before_destroy = true // create a replacement resource, before destroying the original
  }
}

resource "aws_security_group" "instance" {
  name        = "terraform-example-instance"
  description = "Security group for the EC2 instances"

  ingress {
    from_port   = "${var.server_port}"
    to_port     = "${var.server_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "elb" {
  name        = "terraform-example-elb"
  description = "Security group for the Elastic Load Balancer"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_autoscaling_group" "example" {
  launch_configuration = "${aws_launch_configuration.example.id}"

  // get all the availability zones from the data source
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  load_balancers     = ["${aws_elb.example.name}"]
  health_check_type  = "ELB"

  min_size = 2
  max_size = 10

  tag {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true
  }
}

resource "aws_elb" "example" {
  name               = "terraform-asg-example"
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  security_groups    = ["${aws_security_group.elb.id}"]

  listener {
    instance_port     = "${var.server_port}"
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:${var.server_port}/"
  }
}

// data source that reads all availability zones from AWS and makes it available to terraform
// the data source is read-only. Providers are responsible for defining and implementing data sources,
// so for AWS take a look at https://www.terraform.io/docs/providers/aws/index.html
data "aws_availability_zones" "all" {}
