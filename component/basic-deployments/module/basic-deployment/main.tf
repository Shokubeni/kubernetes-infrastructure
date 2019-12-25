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

module "ingress_controller_namespace" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/ingress-controller/namespace.yaml"
  config_path = var.config_path
}

module "ingress_controller_rbac" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/ingress-controller/rbac.yaml"
  config_path = var.config_path
  depends     = [
    module.ingress_controller_namespace.task_id
  ]
}

module "ingress_controller_configmap" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/ingress-controller/configmap.yaml"
  config_path = var.config_path
  variables   = {
    ssh_kube_service = var.network_config.ssh_kube_service
  }
  depends     = [
    module.ingress_controller_namespace.task_id
  ]
}

module "ingress_controller_daemonset" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/ingress-controller/daemonset.yaml"
  config_path = var.config_path
  depends     = [
    module.ingress_controller_namespace.task_id
  ]
}

module "ingress_controller_service" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/ingress-controller/service.yaml"
  config_path = var.config_path
  delay_time  = "120s"
  depends     = [
    module.ingress_controller_namespace.task_id
  ]
}

/*  --------------------------------------------------------------------- */
module "cert_manager_namespace" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/cert-manager/namespace.yaml"
  config_path = var.config_path
}

module "cert_manager_general" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/cert-manager/general.yaml"
  config_path = var.config_path
  delay_time  = "30s"
  depends     = [
    module.cert_manager_namespace.task_id
  ]
}

module "cert_manager_issuer" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/cert-manager/issuer.yaml"
  config_path = var.config_path
  variables   = {
    domain_name = var.network_config.domain_info.domain_name
  }
  depends     = [
    module.cert_manager_namespace.task_id,
    module.cert_manager_general.task_id
  ]
}
