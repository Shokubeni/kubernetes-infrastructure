module "load_balancer" {
  source = "./module/balancer"

  balancer_security = var.balancer_security
  cluster_config    = var.cluster_config
  network_data      = var.network_data
}

module "nat_instance" {
  source = "./module/nat"

  nat_node_security = var.nat_node_security
  cluster_config    = var.cluster_config
  network_config    = var.network_config
  network_data      = var.network_data
}