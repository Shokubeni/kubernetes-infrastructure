variable "virtual_cloud_id" {
  type = "string"
}

variable "cluster_config" {
  type = "map"
}

variable "subnets_zones" {
  type = "list"
}

variable "subnets_cidrs" {
  type = "list"
}