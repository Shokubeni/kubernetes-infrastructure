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

variable "nat_instance_type" {
  type = "string"
}

variable "private_subnets" {
  type = "map"
}

variable "public_subnets" {
  type = "map"
}

variable "deployment_type" {
  type = "string"
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

variable "admin_role" {
  type = "string"
}

variable "root_dir" {
  type = "string"
}