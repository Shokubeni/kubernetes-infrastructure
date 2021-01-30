//**********************************************************************
//*                              Runtime                               *
//**********************************************************************
runtime_config = {
  k8s_version = "1.18"

  auth_accounts = []
  auth_users    = []
  auth_roles    = [{
    rolearn  = "arn:aws:iam::121055255948:role/K8SInfrastructureAdministrator",
    username = "k8s-operations"
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
      namespaces = [
        "basic-deployments",
        "monitoring-tools",
        "metal-city-prod",
      ]
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
    desired_capacity    = 1
    kubelet_extra_args  = {
      "--node-labels" = [
        "node.metal-city.ru/lifecycle=spot",
        "node.metal-city.ru/scope=common",
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
    public_zone = "Z00837602TL6GGSWKOWND"
    domain_name = "metal-city.ru"
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

//TF_VAR_AWS_PROFILE=k8s_operations
//TF_VAR_CLUSTER_NAME=MetalCity
//TF_VAR_CLUSTER_LABEL=metal-city
//TF_VAR_TELEGRAM_TOKEN=1585786952:AAGnFA63WS4347swsKcJwTu1QWvltXO9ltg
//TF_VAR_TELEGRAM_ADMIN=483371842
//TF_VAR_GRAFANA_CLIENT_ID=675212423599-g79iv32vtlj26kbm4vdekpbburu2nlhf.apps.googleusercontent.com
//TF_VAR_GRAFANA_SECRET=07fSjZVD7UknSnoA9LymSWBr
//TF_VAR_KIALI_CLIENT_ID=675212423599-60d5h03lid04e03oc8qv9sipsk5gvb3h.apps.googleusercontent.com
//TF_VAR_KIALI_SECRET=z7VzFxdzgTtzIZ4-VIjDkK-e