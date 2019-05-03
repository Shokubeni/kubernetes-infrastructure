output "cluster_config" {
  value = "${module.common.cluster_config}"
}

output "balancer_data" {
  value = "${module.balancer.balancer_data}"
}

output "network_data" {
  value = "${module.network.network_data}"
}

output "config_path" {
  value = "${module.finalize.config_path}"
}

output "backup_role" {
  value = "${module.security.volume_backup}"
}