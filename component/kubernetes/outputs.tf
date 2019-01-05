output "master_private_key" {
  value = "${module.security.master_private_key}"
}

output "master_public_key" {
  value = "${module.security.master_public_key}"
}

output "worker_private_key" {
  value = "${module.security.worker_private_key}"
}

output "worker_public_key" {
  value = "${module.security.worker_public_key}"
}

output "cluster_id" {
  value = "${random_id.cluster.hex}"
}