output "role_id" {
  value = "${aws_iam_role.lambda.id}"
}

output "role_arn" {
  value = "${aws_iam_role.lambda.arn}"
}