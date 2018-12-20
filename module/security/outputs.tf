output "master_private_key" {
  value = "${module.key_pairs.master_private_key}"
}

output "master_public_key" {
  value = "${module.key_pairs.master_public_key}"
}

output "worker_private_key" {
  value = "${module.key_pairs.worker_private_key}"
}

output "worker_public_key" {
  value = "${module.key_pairs.worker_public_key}"
}