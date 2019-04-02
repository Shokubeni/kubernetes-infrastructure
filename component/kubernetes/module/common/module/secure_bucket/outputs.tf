output "bucket_id" {
  value = "${aws_s3_bucket.bucket.id}"
}

output "bucket_name" {
  value = "${aws_s3_bucket.bucket.bucket_domain_name}"
}

output "bucket_arn" {
  value = "${aws_s3_bucket.bucket.arn}"
}

output "bucket_region" {
  value = "${aws_s3_bucket.bucket.region}"
}