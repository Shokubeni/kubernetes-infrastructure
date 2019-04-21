variable "cluster_role" {
  type = "list"
}

variable "launch_config" {
  type = "map"
}

variable "private_subnet_ids" {
  type = "list"
}

variable "load_balancer_id" {
  type = "string"
}

variable "publish_queue_arn" {
  type = "string"
}

variable "publish_role_arn" {
  type = "string"
}

variable "launch_template_id" {
  type = "string"
}

variable "function_name" {
  type = "string"
}

variable "cluster_config" {
  type = "map"
}