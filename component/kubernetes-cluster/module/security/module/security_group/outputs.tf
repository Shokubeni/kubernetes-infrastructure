output "master_group_id" {
  value = "${aws_security_group.master.id}"
}

output "worker_group_id" {
  value = "${aws_security_group.worker.id}"
}

output "balancer_group_id" {
  value = "${aws_security_group.balancer.id}"
}

output "nat_group_id" {
  value = "${aws_security_group.nat.id}"
}