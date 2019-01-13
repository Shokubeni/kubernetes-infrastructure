output "role_id" {
  value = "${aws_iam_role.publish.id}"
}

output "role_arn" {
  value = "${aws_iam_role.publish.arn}"
}