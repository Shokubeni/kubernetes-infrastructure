variable "provider_profile" {
  type = "string"
}

variable "provider_region" {
  type = "string"
}

variable "cluster_name" {
  type = "string"
}

variable "cluster_label" {
  type = "string"
}

variable "virtual_cloud_cidr" {
  type = "string"
}

variable "use_nat_gateways" {
  type = "string"
}

variable "private_subnets" {
  type = "map"
}

variable "public_subnets" {
  type = "map"
}

variable "master_launch_config" {
  type = "map"
}

variable "master_volume_config" {
  type = "map"
}

variable "worker_launch_config" {
  type = "map"
}

variable "worker_volume_config" {
  type = "map"
}

variable "root_dir" {
  type = "string"
}