output "system_commands" {
  value = "${module.ssm_command.sustem_commands}"
}

output "cluster_id" {
  value = "${module.cluster_initialize.cluster_id}"
}