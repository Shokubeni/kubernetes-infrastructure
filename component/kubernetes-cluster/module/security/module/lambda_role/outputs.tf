output "master_lifecycle_id" {
  value = aws_iam_role.master_lifecycle.id
}

output "master_lifecycle_arn" {
  value = aws_iam_role.master_lifecycle.arn
}

output "worker_lifecycle_id" {
  value = aws_iam_role.worker_lifecycle.id
}

output "worker_lifecycle_arn" {
  value = aws_iam_role.worker_lifecycle.arn
}

output "cloudwatch_event_id" {
  value = aws_iam_role.cloudwatch_event.id
}

output "cloudwatch_event_arn" {
  value = aws_iam_role.cloudwatch_event.arn
}