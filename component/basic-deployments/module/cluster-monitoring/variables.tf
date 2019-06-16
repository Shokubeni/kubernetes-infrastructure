variable "cluster_config" {
  type = "map"
}

variable "domain_config" {
  type = "map"
}

variable "config_path" {
  type = "string"
}

variable "smtp_config" {
  type = "map"
}

variable "slack_channel" {
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