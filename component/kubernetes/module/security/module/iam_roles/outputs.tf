output "master_iam_role_arn" {
  value = "${aws_iam_role.master.arn}"
}

output "worker_iam_role_arn" {
  value = "${aws_iam_role.worker.arn}"
}