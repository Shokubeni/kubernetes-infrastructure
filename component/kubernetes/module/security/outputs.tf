output "master_security_group_id" {
  value = "${module.security_groups.master_security_group_id}"
}

output "worker_security_group_id" {
  value = "${module.security_groups.worker_security_group_id}"
}

output "master_iam_role_arn" {
  value = "${module.iam_roles.master_iam_role_arn}"
}

output "worker_iam_role_arn" {
  value = "${module.iam_roles.worker_iam_role_arn}"
}

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