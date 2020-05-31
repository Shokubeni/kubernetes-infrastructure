output "autoscaling_group_arns" {
  value = aws_autoscaling_group.autoscaling.*.arn
}

output "autoscaling_group_ids" {
  value = aws_autoscaling_group.autoscaling.*.id
}