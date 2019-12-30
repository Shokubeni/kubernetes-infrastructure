variable "master_node_config" {
  type = object({
    instance = object({
      instance_types        = list(string)
      shutdown_behavior     = string
      cpu_credits           = string
      disable_termination   = bool
      ebs_optimized         = bool
      monitoring            = bool
      max_price             = number
      min_size              = number
      max_size              = number
      on_demand_capasity    = number
      desired_capacity      = number
    })
    volume = object({
      delete_on_termination = bool
      volume_type           = string
      volume_size           = number
    })
  })
}

variable "worker_node_config" {
  type = object({
    instance = object({
      instance_types        = list(string)
      shutdown_behavior     = string
      cpu_credits           = string
      disable_termination   = bool
      ebs_optimized         = bool
      monitoring            = bool
      max_price             = number
      min_size              = number
      max_size              = number
      on_demand_capasity    = number
      desired_capacity      = number
    })
    volume = object({
      delete_on_termination = bool
      volume_type           = string
      volume_size           = number
    })
  })
}

variable "nodes_runtime_config" {
  type = object({
    token_schedule  = string
    is_prod_env     = bool

    backups = object({
      schedule      = string
      ttl           = string
      namespaces    = list(string)
      resources     = list(string)
    })

    cluster = object({
      kubernetes    = string
      docker        = string
    })
  })
}

variable "network_config" {
  type = object({
    virtual_cloud_cidr = string
    nat_instance_type  = string
    is_main_cluster    = bool
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

variable "provider_profile" {
  type = string
}

variable "provider_region" {
  type = string
}

variable "backend_bucket" {
  type = string
}

variable "backend_region" {
  type = string
}

variable "smtp_host" {
  type = string
}

variable "smtp_port" {
  type = string
}

variable "smtp_alerts_user" {
  type = string
}

variable "smtp_alerts_pass" {
  type = string
}

variable "smtp_metrics_user" {
  type = string
}

variable "smtp_metrics_pass" {
  type = string
}

variable "slack_channel" {
  type = string
}

variable "slack_hook" {
  type = string
}

variable "kube_config" {
  type = string
}

variable "admin_role" {
  type = string
}

variable "grafana_client_id" {
  type = string
}

variable "grafana_secret" {
  type = string
}
