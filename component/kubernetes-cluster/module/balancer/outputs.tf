output "balancer_data" {
  value = {
    zone = module.load_balancer.zone_id
    dns  = module.load_balancer.dns_name
    id   = module.load_balancer.id
  }
}

output "nat_data" {
  value = {
    ids = module.nat_instance.nat_nodes_ids
  }
}