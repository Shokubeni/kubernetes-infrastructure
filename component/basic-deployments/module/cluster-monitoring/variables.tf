variable "network_config" {
  type = object({
    virtual_cloud_cidr = string
    nat_instance_type  = string
    private_subnets    = map(string)
    public_subnets     = map(string)
    tcp_services       = map(string)
    udp_services       = map(string)
    domain_info        = object({
      hosted_zone = string
      domain_name = string
    })
  })
}

variable "smtp_config" {
  type = object({
    host         = string
    port         = string
    metrics_user = string
    metrics_pass = string
    alerts_user  = string
    alerts_pass  = string
  })
}

variable "cluster_config" {
  type = object({
    id         = string
    name       = string
    label      = string
    account    = string
    region     = string
    prod       = bool
  })
}

variable "config_path" {
  type = string
}

variable "slack_channel" {
  type = string
}

variable "slack_hook" {
  type = string
}

variable "grafana_client_id" {
  type = string
}

variable "grafana_secret" {
  type = string
}
