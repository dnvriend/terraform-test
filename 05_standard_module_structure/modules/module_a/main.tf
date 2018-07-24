
resource "aws_instance" "example" {
  ami           = "ami-466768ac" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t2.nano"

  tags {
    Organization = "com.github.dnvriend"
    Department = "Development"
    Name = "terraform-example"
  }
}