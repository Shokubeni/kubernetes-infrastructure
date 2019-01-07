output "virtual_cloud_id" {
  value = "${module.virtual_cloud.cloud_id}"
}

output "internet_gateway_id" {
  value = "${module.internet_gateway.gateway_id}"
}

output "nat_gateway_ids" {
  value = "${module.nat_gateway.gateway_ids}"
}

output "private_subnet_ids" {
  value = "${module.private_subnet.subnet_ids}"
}

output "public_subnet_ids" {
  value = "${module.public_subnet.subnet_ids}"
}