# 01_ec2_instance
Provision a small ec2 instance using the configured AWS_PROFILE and AWS_REGION

## Deploying the infrastructure
First the directory has to be initialized. This can be done via the `terraform init` command, which initializes 
the workdir with the `.terraform` directory that contains the `plugins` which will contain a provider that has
been configured.

```hcl-terraform
provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "example" {
  ami           = "ami-466768ac" // Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t2.nano"
}
```

Next, terraform can generate and show an execution plan with the `terraform plan` command. Finally, the infrastructure 
can be deployed with the `terraform apply` command that will create the infrastructure. When the infrastructure has 
been deployed, we can use the `terraform show` command to show the state of the infrastructure. Effectively it dumps
the currently deployed state of the infrastructure to the console. 

## Updating resources
Lets make a small change, and change the `t2.micro` instance to a `t2.small`, and execute a `terraform plan`, that will 
result in an `update-in-place` operation. Also, apply the change with `terraform apply` and a `show` to see the results:

```hcl-terraform
provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "example" {
  ami           = "ami-466768ac" // Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t2.small"
}
```

Lets now add some tags:

```hcl-terraform
provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "example" {
  ami           = "ami-466768ac" // Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t2.small"

  tags {
    Organization = "com.github.dnvriend"
    Department = "Development"
    Name = "terraform-example"
  }
}
```

Lets first look at the `plan` and then `apply` the change. This should also update the resource in place. 

## Removing all resources
Lets finally remove all resources with the `terraform destroy` command.



