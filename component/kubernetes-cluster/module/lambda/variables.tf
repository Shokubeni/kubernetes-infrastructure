variable "cluster_config" {
  type = "map"
}

variable "system_commands" {
  type = "map"
}

variable "backup_bucket" {
  type = "map"
}

variable "secure_bucket" {
  type = "map"
}

variable "master_queue" {
  type = "map"
}

variable "worker_queue" {
  type = "map"
}

variable "cloudwatch_role" {
  type = "map"
}

variable "master_role" {
  type = "map"
}

variable "worker_role" {
  type = "map"
}

variable "balancer_data" {
  type = "map"
}