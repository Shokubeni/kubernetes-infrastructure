output "private_subnets_ids" {
  value = "${module.private_subnets.subnets_ids}"
}

output "public_subnets_ids" {
  value = "${module.public_subnets.subnets_ids}"
}

output "virtual_cloud_id" {
  value = "${module.virtual_cloud.virtual_cloud_id}"
}