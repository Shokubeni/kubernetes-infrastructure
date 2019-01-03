output "master_iam_role_id" {
  value = "${aws_iam_role.master.id}"
}

output "worker_iam_role_id" {
  value = "${aws_iam_role.worker.id}"
}