output "autoscaling_iam_role_id" {
  value = "${module.autoscaling_role.role_id}"
}

output "master_security_group_id" {
  value = "${module.security_group.master_group_id}"
}

output "master_iam_role_id" {
  value = "${module.node_role.master_role_id}"
}

output "master_private_key" {
  value = "${module.tls_key_pair.master_private_key}"
}

output "master_public_key" {
  value = "${module.tls_key_pair.master_public_key}"
}

output "master_key_id" {
  value = "${module.tls_key_pair.master_key_id}"
}

output "worker_security_group_id" {
  value = "${module.security_group.worker_group_id}"
}

output "worker_iam_role_id" {
  value = "${module.node_role.worker_role_id}"
}

output "worker_private_key" {
  value = "${module.tls_key_pair.worker_private_key}"
}

output "worker_public_key" {
  value = "${module.tls_key_pair.worker_public_key}"
}

output "worker_key_id" {
  value = "${module.tls_key_pair.worker_key_id}"
}