output "master_role_id" {
  value = "${aws_iam_role.master.id}"
}

output "master_role_arn" {
  value = "${aws_iam_role.master.arn}"
}

output "worker_role_id" {
  value = "${aws_iam_role.worker.id}"
}

output "worker_role_arn" {
  value = "${aws_iam_role.worker.arn}"
}