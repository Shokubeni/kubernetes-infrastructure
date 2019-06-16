variable "provider_profile" {
  type = "string"
}

variable "provider_region" {
  type = "string"
}

variable "backend_bucket" {
  type = "string"
}

variable "backend_region" {
  type = "string"
}

variable "domain_config" {
  type = "map"
}

variable "is_main_cluster" {
  type = "string"
}

variable "virtual_cloud_cidr" {
  type = "string"
}

variable "smtp_host" {
  type = "string"
}

variable "smtp_port" {
  type = "string"
}

variable "smtp_alerts_user" {
  type = "string"
}

variable "smtp_alerts_pass" {
  type = "string"
}

variable "smtp_metrics_user" {
  type = "string"
}

variable "smtp_metrics_pass" {
  type = "string"
}

variable "slack_channel" {
  type = "string"
}

variable "kube_config" {
  type = "string"
}

variable "admin_role" {
  type = "string"
}

variable "slack_hook" {
  type = "string"
}

variable "okta_url" {
  type = "string"
}

variable "grafana_client_id" {
  type = "string"
}

variable "grafana_secret" {
  type = "string"
}