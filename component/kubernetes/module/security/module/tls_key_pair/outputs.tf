output "master_private_key" {
  value = "${tls_private_key.master.private_key_pem}"
}

output "master_public_key" {
  value = "${tls_private_key.master.public_key_pem}"
}

output "master_key_id" {
  value = "${aws_key_pair.master.id}"
}

output "worker_private_key" {
  value = "${tls_private_key.worker.private_key_pem}"
}

output "worker_public_key" {
  value = "${tls_private_key.worker.public_key_pem}"
}

output "worker_key_id" {
  value = "${aws_key_pair.worker.id}"
}
