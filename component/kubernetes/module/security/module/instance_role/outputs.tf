output "master_role_id" {
  value = "${aws_iam_role.master.id}"
}

output "worker_role_id" {
  value = "${aws_iam_role.worker.id}"
}