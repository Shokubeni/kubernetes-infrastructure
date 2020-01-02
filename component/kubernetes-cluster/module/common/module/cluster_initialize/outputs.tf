output "cluster_id" {
  value = random_id.cluster.hex
}

output "cluster_name" {
  value = local.name
}

output "cluster_label" {
  value = local.label
}

output "account_id" {
  value = data.aws_caller_identity.default.account_id
}

output "region_name" {
  value = data.aws_region.default.name
}
