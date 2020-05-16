//**********************************************************************
//*                              Runtime                               *
//**********************************************************************
nodes_runtime_config = {
  iam_access = [
    {
      role   = "arn:aws:iam::121055255948:role/OCPProductionAdministrator",
      name   = "ocp-prod-admin"
      groups = [
        "ocp-prod:admin"
      ]
    },
    {
      role   = "arn:aws:iam::121055255948:role/KubernetesClusterOperator",
      name   = "cluster-operator"
      groups = [
        "system:masters"
      ]
    }
  ]

  token_schedule  = "rate(12 hours)"
  prod_cluster    = true

  cluster = {
    authenticator = "1.16.8/2020-04-16"
    kubernetes    = "1.16.9"
    docker        = "5:19.03.0"
    velero        = "1.3.2"
  }

  backups = {
    schedule      = "cron(0 0 ? * * *)"
    lifetime      = "360h0m0s"
    resources     = ["*"]
    namespaces    = [
      "basic-deployments",
      "network-services",
      "monitoring-tools",
      "command-center",
      "gitlab-runners",
      "ocp-production",
    ]
  }
}

//**********************************************************************
//*                               Nodes                                *
//**********************************************************************
master_node_config = {
  instance = {
    instance_types        = ["t3a.large", "t3.large", "t2.large"]
    shutdown_behavior     = "terminate"
    cpu_credits           = "standard"
    disable_termination   = false
    ebs_optimized         = false
    monitoring            = false
    max_price             = 0.08
    min_size              = 1
    max_size              = 3
    on_demand_capasity    = 0
    desired_capacity      = 2
  }

  volume = {
    delete_on_termination = true
    volume_type           = "gp2"
    volume_size           = 30
    iops                  = null
  }
}

worker_node_config = {
  instance = {
    instance_types        = ["t3a.xlarge", "t3.xlarge", "t2.xlarge"]
    shutdown_behavior     = "terminate"
    cpu_credits           = "standard"
    disable_termination   = false
    ebs_optimized         = false
    monitoring            = false
    max_price             = 0.08
    min_size              = 1
    max_size              = 5
    on_demand_capasity    = 0
    desired_capacity      = 2
  }

  volume = {
    delete_on_termination = true
    volume_type           = "gp2"
    volume_size           = 30
    iops                  = null
  }
}

//**********************************************************************
//*                              Network                               *
//**********************************************************************
network_config = {
  virtual_cloud_cidr = "172.16.0.0/16"
  vpn_clients_cidr   = "10.0.0.0/8"
  nat_instance_type  = "t3a.micro"

  private_subnets    = {
    "172.16.0.0/20"  = "us-east-1a"
    "172.16.16.0/20" = "us-east-1b"
  }

  public_subnets     = {
    "172.16.32.0/20" = "us-east-1a"
    "172.16.48.0/20" = "us-east-1b"
  }

  domain_info        = {
    private_zone = "Z08751802222O6NWU3PMC"
    public_zone  = "Z1IMWHN7BIT6US"
    domain_name  = "smart-gears.io"
  }

  tcp_services = [
    {
      namespace = "network-services"
      workload  = "openvpn"
      port      = 1194
    },
    {
      namespace = "command-center"
      workload  = "gitlab"
      port      = 22
    },
  ]

  udp_services = []
}
