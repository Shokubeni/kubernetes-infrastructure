output "master_group_id" {
  value = "${aws_security_group.master.id}"
}

output "worker_group_id" {
  value = "${aws_security_group.worker.id}"
}