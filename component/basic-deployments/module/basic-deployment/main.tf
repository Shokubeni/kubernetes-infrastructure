module "cluster_autoscaler_rbac" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/autoscaler/rbac.yaml"
  config_path = "${var.config_path}"
}

module "cluster_autoscaler_daemonset" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/autoscaler/daemonset.yaml"
  config_path = "${var.config_path}"
  variables   = {
    cluster_id = "${var.cluster_config["id"]}"
  }
}

/* ------------------------------------------------------------------------- */

module "authenticator_configmap" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/authenticator/configmap.yaml"
  config_path = "${var.config_path}"
  variables = {
    cluster_id = "${var.cluster_config["id"]}"
    admin_role = "${var.admin_role}"
  }
}

module "authenticator_daemonset" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/authenticator/daemonset.yaml"
  config_path = "${var.config_path}"
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
module "kube_lego_rbac" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/kube-lego/rbac.yaml"
  config_path = "${var.config_path}"
}

module "kube_lego_configmap" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/kube-lego/configmap.yaml"
  config_path = "${var.config_path}"
  variables   = {
    domain_name = "${var.domain_config["domain_name"]}"
    acme_stage  = "${
        var.cluster_config["type"] == "production"
            ? "acme-v01.api.letsencrypt.org/directory"
            : "acme-staging-v02.api.letsencrypt.org/directory"
        }"
  }
}

module "kube_lego_daemonset" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/kube-lego/daemonset.yaml"
  config_path = "${var.config_path}"
}