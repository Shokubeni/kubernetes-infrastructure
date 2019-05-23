module "load_balancer" {
  source = "./module/balancer"

  balancer_security = "${var.balancer_security}"
  cluster_config    = "${var.cluster_config}"
  network_data      = "${var.network_data}"
}

module "nat_instance" {
  source = "./module/nat"

  nat_instance_type = "${var.nat_instance_type}"
  cluster_config    = "${var.cluster_config}"
  private_subnets   = "${var.private_subnets}"
  public_subnets    = "${var.public_subnets}"
  nat_security      = "${var.nat_node_security}"
  network_data      = "${var.network_data}"
}