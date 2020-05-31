output "backup_user_id" {
  value = aws_iam_user.backup.id

  depends_on = [
    aws_iam_user_policy.backup,
    aws_iam_user.backup
  ]
}

output "backup_user_arn" {
  value = aws_iam_user.backup.arn

  depends_on = [
    aws_iam_user_policy.backup,
    aws_iam_user.backup
  ]
}