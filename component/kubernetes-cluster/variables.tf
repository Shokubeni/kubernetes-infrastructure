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
    token_schedule = string
    prod_cluster   = bool

    backups = object({
      schedule     = string
      lifetime     = string
      namespaces   = list(string)
      resources    = list(string)
    })

    cluster = object({
      kubernetes   = string
      docker       = string
    })
  })
}

variable "network_config" {
  type = object({
    virtual_cloud_cidr = string
    vpn_clients_cidr   = string
    nat_instance_type  = string
    private_subnets    = map(string)
    public_subnets     = map(string)
    tcp_services       = map(string)
    udp_services       = map(string)
    domain_info        = object({
      private_zone = string
      public_zone  = string
      domain_name  = string
    })
  })
}

variable "provider_profile" {
  type = string
}

variable "provider_region" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "cluster_label" {
  type = string
}

variable "root_dir" {
  type = string
}
