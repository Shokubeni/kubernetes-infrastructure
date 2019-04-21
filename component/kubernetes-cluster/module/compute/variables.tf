variable "cluster_role" {
  type = "list"
}

variable "cluster_config" {
  type = "map"
}

variable "network_data" {
  type = "map"
}

variable "balancer_data" {
  type = "map"
}

variable "launch_config" {
  type = "map"
}

variable "volume_config" {
  type = "map"
}

variable "lifecycle_queue" {
  type = "map"
}

variable "lifecycle_function" {
  type = "map"
}

variable "publish_role" {
  type = "map"
}

variable "node_security" {
  type = "map"
}

variable "use_nat_gateway" {
  type = "string"
}