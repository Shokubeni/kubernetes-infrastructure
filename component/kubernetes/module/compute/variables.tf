variable "cluster_role" {
  type = "list"
}

variable "private_subnet_ids" {
  type = "list"
}

variable "private_subnets" {
  type = "map"
}

variable "security_group_id" {
  type = "string"
}

variable "autoscale_role_id" {
  type = "string"
}

variable "node_role_id" {
  type = "string"
}

variable "key_pair_id" {
  type = "string"
}

variable "launch_config" {
  type = "map"
}

variable "volume_config" {
  type = "map"
}

variable "cluster_config" {
  type = "map"
}

variable "cluster_id" {
  type = "string"
}