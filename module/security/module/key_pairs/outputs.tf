output "master_key_name" {
  value = "${aws_key_pair.master_node.key_name}"
}

output "master_key_fingerprint" {
  value = "${aws_key_pair.master_node.fingerprint}"
}

output "worker_key_name" {
  value = "${aws_key_pair.worker_node.key_name}"
}

output "worker_key_fingerprint" {
  value = "${aws_key_pair.worker_node.fingerprint}"
}