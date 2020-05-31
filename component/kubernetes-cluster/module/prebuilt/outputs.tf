output "cluster_data" {
  value = {
    id      = random_id.cluster_identity.hex
    account = data.aws_caller_identity.default.account_id
    region  = data.aws_region.default.name
    label   = var.cluster_label
    name    = var.cluster_name
  }
}
