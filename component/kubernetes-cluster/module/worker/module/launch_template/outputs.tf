output "launch_template_arns" {
  value = aws_launch_template.workers.*.arn
}

output "launch_template_ids" {
  value = aws_launch_template.workers.*.id
}