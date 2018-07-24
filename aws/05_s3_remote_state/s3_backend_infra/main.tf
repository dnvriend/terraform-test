provider "aws" {
  region = "eu-west-1"
}

resource "aws_s3_bucket" "state" {
  bucket = "${var.s3_bucket_name}"
  region = "${var.s3_bucket_region}"

  versioning {
    enabled = true
  }

  tags {
    Name = "terraform bucket"
  }

  server_side_encryption_configuration {
    "rule" {
      "apply_server_side_encryption_by_default" {
        sse_algorithm = "AES256"
      }
    }
  }

  acceleration_status = "Suspended"
}

data "aws_iam_policy_document" "s3_access" {
  statement {
    sid = "1"
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::*",
    ]
  }
}

resource "aws_iam_policy" "s3_bucket_policy" {
  description = "gives terraform access to s3"
  name   = "s3_bucket_permission"
  path   = "/"
  policy = "${data.aws_iam_policy_document.s3_access.json}"
}

resource "aws_kms_key" "key" {
  description = "the kms key to encrypt the terraform state file"
}

//data "aws_iam_policy_document" "dynamodb_access" {
//  statement {
//    sid = "1"
//    actions = [
//      "dynamodb:GetItem",
//      "dynamodb:PutItem",
//      "dynamodb:DeleteItem",
//    ]
//
//    resources = [
//      "arn:aws:dynamodb:*:*:table/mytable",
//    ]
//  }
//}

//resource "aws_iam_policy" "dynamodb_policy" {
//  name   = "dynamodb_permission"
//  path   = "/"
//  policy = "${data.aws_iam_policy_document.dynamodb_access.json}"
//}
//
//resource "aws_dynamodb_table" "state" {
//  "attribute" {
//    name = "LockID"
//    type = "string"
//  }
//  hash_key = "LockID"
//  name = "terraform_lock_table"
//  read_capacity = 1
//  write_capacity = 1
//}


