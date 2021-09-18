//**********************************************************************
//*                              Runtime                               *
//**********************************************************************
runtime_config = {
  k8s_version = "1.21"

  auth_accounts = []
  auth_users    = []
  auth_roles    = [{
    rolearn  = "<role-arn>",
    username = "<user-name>"
    groups = [
      "system:masters"
    ]
  }]

  backups = [{
    name     = "all-cluster"
    schedule = "0 3 * * *"
    lifetime = "360h0m0s"
    include  = {
      resources  = ["*"]
      namespaces = []
    }
    exclude = {
      resources  = []
      namespaces = []
    }
  }]
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
    desired_capacity    = 2
    kubelet_extra_args  = {
      "--node-labels" = [
        "worker-node/lifecycle=spot",
        "worker-node/scope=common",
      ]
    }
    instance_types = [
      "t3.large",
      "t3.medium",
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
  nat_instance_type  = "t3.micro"
  cluster_services   = [{
    name: "open-vpn"
    ports: {
      gateway: 31194
      service: 1194
    }
  }]

  domain_info = {
    public_zone = ""
    domain_name = ""
  }

  private_subnets = {
    "172.16.0.0/20"  = "eu-north-1a",
    "172.16.16.0/20" = "eu-north-1b"
  }

  public_subnets = {
    "172.16.32.0/20" = "eu-north-1a",
    "172.16.48.0/20" = "eu-north-1b"
  }
}