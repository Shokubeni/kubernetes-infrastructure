output "backup_user_id" {
  value = "${aws_iam_user.backup.id}"
}

output "backup_user_arn" {
  value = "${aws_iam_user.backup.arn}"
}