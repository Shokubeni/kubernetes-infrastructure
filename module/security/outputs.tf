output "master_key_name" {
  value = "${module.key_pairs.master_key_name}"
}

output "master_key_fingerpint" {
  value = "${module.key_pairs.master_key_fingerprint}"
}

output "worker_key_name" {
  value = "${module.key_pairs.worker_key_name}"
}

output "worker_key_fingerprint" {
  value = "${module.key_pairs.worker_key_fingerprint}"
}