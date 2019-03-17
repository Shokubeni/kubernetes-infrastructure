output "master_publish_id" {
  value = "${aws_iam_role.master_publish.id}"
}

output "master_publish_arn" {
  value = "${aws_iam_role.master_publish.arn}"
}

output "worker_publish_id" {
  value = "${aws_iam_role.worker_publish.id}"
}

output "worker_publish_arn" {
  value = "${aws_iam_role.worker_publish.arn}"
}