# s3_backend_infra
S3 Backend infrastructure. The `terraform.tfstate` file will be kept local. There are no credentials in this file.

## Resources
Creates the following resources:

- s3
- s3 access policy
- kms key

## Outputs
Outputs the following

- s3 arn
- s3 access policy arn
- kms key arn

## Installation
Use the terraform `plan`, `apply`, `show` and `destroy` commands. 