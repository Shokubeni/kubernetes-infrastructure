module "cluster_autoscaler_rbac" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/cluster-autoscaler/rbac.yaml"
  config_path = "${var.config_path}"
}

module "ingress_controller_deployment" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/cluster-autoscaler/deployment.yaml"
  config_path = "${var.config_path}"
  variables   = {
    cluster_id = "${var.cluster_config["id"]}"
  }
}

/*  --------------------------------------------------------------------- */

module "ingress_controller_namespace" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/ingress-controller/namespace.yaml"
  config_path = "${var.config_path}"
}

module "ingress_controller_rbac" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/ingress-controller/rbac.yaml"
  config_path = "${var.config_path}"
  depends_on  = [
    "${module.ingress_controller_namespace.task_id}"
  ]
}

module "ingress_controller_configmap" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/ingress-controller/configmap.yaml"
  config_path = "${var.config_path}"
  depends_on  = [
    "${module.ingress_controller_namespace.task_id}"
  ]
}

module "ingress_controller_daemonset" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/ingress-controller/daemonset.yaml"
  config_path = "${var.config_path}"
  depends_on  = [
    "${module.ingress_controller_namespace.task_id}"
  ]
}

module "ingress_controller_service" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/ingress-controller/service.yaml"
  config_path = "${var.config_path}"
  delay_time  = "120s"
  depends_on  = [
    "${module.ingress_controller_namespace.task_id}"
  ]
}

/*  --------------------------------------------------------------------- */

module "kube_lego_namespace" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/kube-lego/namespace.yaml"
  config_path = "${var.config_path}"
}

module "kube_lego_rbac" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/kube-lego/rbac.yaml"
  config_path = "${var.config_path}"
  depends_on  = [
    "${module.kube_lego_namespace.task_id}"
  ]
}

module "kube_lego_configmap" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/kube-lego/configmap.yaml"
  config_path = "${var.config_path}"
  variables   = {
    domain_name = "${var.domain_config["domain_name"]}"
  }
  depends_on  = [
    "${module.kube_lego_namespace.task_id}"
  ]
}

module "kube_lego_daemonset" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/kube-lego/daemonset.yaml"
  config_path = "${var.config_path}"
  depends_on  = [
    "${module.kube_lego_namespace.task_id}"
  ]
}