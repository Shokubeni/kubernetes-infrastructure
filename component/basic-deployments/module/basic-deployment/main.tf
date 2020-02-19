module "cluster_autoscaler_rbac" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/autoscaler/rbac.yaml"
  config_path = var.config_path
}

module "cluster_autoscaler_daemonset" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/autoscaler/daemonset.yaml"
  config_path = var.config_path
  variables   = {
    cluster_id = var.cluster_config.id
  }
}

/* ------------------------------------------------------------------------- */

module "authenticator_configmap" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/authenticator/configmap.yaml"
  config_path = var.config_path
  variables = {
    cluster_id = var.cluster_config.id
    admin_role = var.admin_role
  }
}

module "authenticator_daemonset" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/authenticator/daemonset.yaml"
  config_path = var.config_path
}

/*  --------------------------------------------------------------------- */
module "ingress_nginx_rbac" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/ingress-nginx/rbac.yaml"
  config_path = var.config_path
}

module "ingress_nginx_configmap" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/ingress-nginx/configmap.yaml"
  config_path = var.config_path
  variables   = {
    tcp_services = join("\n  ", [for port, service in var.network_config.tcp_services : "${port}: ${service}"])
    udp_services = join("\n  ", [for port, service in var.network_config.udp_services : "${port}: ${service}"])
  }
}

module "ingress_nginx_daemonset" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/ingress-nginx/daemonset.yaml"
  config_path = var.config_path
}

module "ingress_nginx_service" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/ingress-nginx/service.yaml"
  config_path = var.config_path
  delay_time  = "120s"
}

/*  --------------------------------------------------------------------- */
module "cert_manager_general" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/cert-manager/general.yaml"
  config_path = var.config_path
}

module "cert_manager_issuer" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/cert-manager/issuer.yaml"
  config_path = var.config_path
  variables   = {
    domain_name = var.network_config.domain_info.domain_name
  }
}

/*  --------------------------------------------------------------------- */
module "open_vpn_configmap" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/open-vpn/configmap.yaml"
  config_path = var.config_path
}

module "open_vpn_service" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/open-vpn/service.yaml"
  config_path = var.config_path
}

module "open_vpn_volume" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/open-vpn/volume.yaml"
  config_path = var.config_path
}

module "open_vpn_deployment" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/open-vpn/deployment.yaml"
  config_path = var.config_path
}
