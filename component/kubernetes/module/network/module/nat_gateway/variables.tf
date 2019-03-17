variable "use_nat_gateways" {
  type = "string"
}

variable "virtual_cloud_id" {
  type = "string"
}

variable "private_subnets_count" {
  type = "string"
}

variable "private_subnets_ids" {
  type = "list"
}

variable "public_subnets_count" {
  type = "string"
}

variable "public_subnets_ids" {
  type = "list"
}

variable "cluster_config" {
  type = "map"
}