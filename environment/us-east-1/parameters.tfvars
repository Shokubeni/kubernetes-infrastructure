//**********************************************************************
//*                              Runtime                               *
//**********************************************************************
runtime_config = {
  k8s_version = "1.16"

  auth_accounts = []
  auth_users    = []
  auth_roles    = [
    {
      rolearn  = "arn:aws:iam::121055255948:role/K8SInfrastructureAdministrator",
      username = "k8s-operations"
      groups = [
        "system:masters"
      ]
    },
    {
      rolearn  = "arn:aws:iam::121055255948:role/OCPProductionAdministrator",
      username = "ocp-production"
      groups = [
        "ocp-prod:admin"
      ]
    }
  ]

  backups = {
    schedule   = "cron(0 0 ? * * *)"
    lifetime   = "360h0m0s"
    resources  = ["*"]
    namespaces = [
      "basic-deployments",
      "monitoring-tools",
      "command-center",
      "gitlab-runners",
      "ocp-production",
    ]
  }

  logs = {
    retention = 7,
    types = [
      "controllerManager",
      "authenticator",
      "scheduler",
      "audit",
      "api"
    ]
  }
}

//**********************************************************************
//*                               Nodes                                *
//**********************************************************************
worker_configs = [{
  instance = {
    node_group_label    = "common-workers"
    shutdown_behavior   = "terminate"
    cpu_credits         = "standard"
    disable_termination = false
    ebs_optimized       = false
    monitoring          = false
    max_price           = 0.08
    min_size            = 1
    max_size            = 5
    on_demand_capasity  = 0
    desired_capacity    = 3
    kubelet_extra_args  = {
      "--node-labels" = [
        "node.smart-gears.io/lifecycle=spot",
        "node.smart-gears.io/scope=common",
      ]
    }
    instance_types = [
      "t3a.xlarge",
      "t3.xlarge",
      "t2.xlarge"
    ]
  }

  volume = {
    volume_type = "gp2"
    volume_size = 30
    termination = true
    iops        = null
  }
}]

//**********************************************************************
//*                              Network                               *
//**********************************************************************
network_config = {
  virtual_cloud_cidr = "172.16.0.0/16"
  vpn_clients_cidr   = "10.0.0.0/8"
  nat_instance_type  = "t3a.micro"

  private_subnets = {
    "172.16.0.0/20"  = "us-east-1a"
    "172.16.16.0/20" = "us-east-1b"
  }

  public_subnets = {
    "172.16.32.0/20" = "us-east-1a"
    "172.16.48.0/20" = "us-east-1b"
  }

  domain_info = {
    private_zone = "Z08751802222O6NWU3PMC"
    public_zone  = "Z1IMWHN7BIT6US"
    domain_name  = "smart-gears.io"
  }
}
