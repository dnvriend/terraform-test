# web server
Provisions a web server in the default public VPC, and store the terraform state in an s3 remote backend.

## Resources
Creates the following resources:

- aws_instance
- aws_security_group

## Outputs
Outputs the following

- web_server_public_ip

## Installation
Use the terraform `plan`, `apply`, `show` and `destroy` commands. 