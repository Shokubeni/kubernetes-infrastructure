variable "master_security_group_id" {
  type = "string"
}

variable "master_iam_role_id" {
  type = "string"
}

variable "master_key_name" {
  type = "string"
}

variable "master_node_instance" {
  type = "map"
}

variable "master_root_volume" {
  type = "map"
}

variable "worker_security_group_id" {
  type = "string"
}

variable "worker_iam_role_id" {
  type = "string"
}

variable "worker_key_name" {
  type = "string"
}

variable "worker_node_instance" {
  type = "map"
}

variable "worker_root_volume" {
  type = "map"
}

variable "private_subnets_ids" {
  type = "list"
}

variable "private_subnets" {
  type = "map"
}

variable "public_subnets_ids" {
  type = "string"
}

variable "public_subnets" {
  type = "map"
}

variable "virtual_cloud_id" {
  type = "string"
}

variable "cluster_config" {
  type = "map"
}