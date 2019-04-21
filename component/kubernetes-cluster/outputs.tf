output "balancer_zone" {
  value = "${module.balancer.balancer_data["zone"]}"
}

output "balancer_dns" {
  value = "${module.balancer.balancer_data["dns"]}"
}

output "config_path" {
  value = "${module.finalize.config_path}"
}