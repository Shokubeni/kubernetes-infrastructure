output "openid_provider" {
  value = module.cluster.openid_provider
}

output "control_plane" {
  value = module.cluster.control_plane
}

output "cluster_data" {
  value = module.prebuilt.cluster_data
}

output "network_data" {
  value = module.network.network_data
}
