output "s3_bucket_policy_arn" {
  value = "${aws_iam_policy.s3_bucket_policy.arn}"
}

output "s3_bucket_arn" {
  value = "${aws_s3_bucket.state.arn}"
}

output "kms_arn" {
  value = "${aws_kms_key.key.arn}"
}


