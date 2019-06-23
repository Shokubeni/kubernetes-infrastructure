output "bucket_id" {
  value = aws_s3_bucket.backup.id
}

output "bucket_name" {
  value = aws_s3_bucket.backup.bucket_domain_name
}

output "bucket_arn" {
  value = aws_s3_bucket.backup.arn
}

output "bucket_region" {
  value = aws_s3_bucket.backup.region
}