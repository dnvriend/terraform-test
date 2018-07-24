variable "s3_bucket_name" {
  description = "The name of the s3 bucket"
  default = "dnvriend-terraform-state"
  type = "string"
}

variable "s3_bucket_region" {
  description = "The region of the s3 bucket"
  default = "eu-west-1"
  type = "string"
}

