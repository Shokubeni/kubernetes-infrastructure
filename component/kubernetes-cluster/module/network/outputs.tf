output "network_data" {
  value = {
    virtual_cloud_id    = "${module.virtual_cloud.cloud_id}"
    internet_gateway_id = "${module.internet_gateway.gateway_id}"
    nat_gateway_ids     = "${join(",", module.nat_gateway.gateway_ids)}"
    private_subnet_ids  = "${join(",", module.private_subnet.subnet_ids)}"
    public_subnet_ids   = "${join(",", module.public_subnet.subnet_ids)}"
  }
}