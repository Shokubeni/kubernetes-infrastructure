resource "aws_backup_vault" "monitoring" {
  name = "${var.cluster_config["label"]}-monitoring_${var.cluster_config["id"]}"
}

resource "aws_backup_plan" "monitoring" {
  name = "${var.cluster_config["label"]}-monitoring_${var.cluster_config["id"]}"

  rule {
    target_vault_name = "${aws_backup_vault.monitoring.name}"
    rule_name         = "DailyBackups"
    schedule          = "cron(0 0 ? * * *)"

    lifecycle {
      delete_after = 7
    }
  }
}

resource "aws_backup_selection" "monitoring" {
  name         = "services"
  plan_id      = "${aws_backup_plan.monitoring.id}"
  iam_role_arn = "${var.backup_role["arn"]}"

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "kubernetes.io/cluster/${var.cluster_config["id"]}"
    value = "owned"
  }

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "kubernetes.io/created-for/pvc/namespace"
    value = "monitoring"
  }
}

module "monitoring_namespace" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/namespace.yaml"
  config_path = "${var.config_path}"
}

/* ------------------------------------------------------------------------- */

module "prometheus_rbac" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/prometheus/rbac.yaml"
  config_path = "${var.config_path}"
  depends_on  = [
    "${module.monitoring_namespace.task_id}"
  ]
}

module "prometheus_configmap" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/prometheus/configmap.yaml"
  config_path = "${var.config_path}"
  depends_on  = [
    "${module.monitoring_namespace.task_id}"
  ]
}

module "prometheus_volume" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/prometheus/volume.yaml"
  config_path = "${var.config_path}"
  depends_on  = [
    "${module.monitoring_namespace.task_id}"
  ]
}

module "prometheus_deployment" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/prometheus/deployment.yaml"
  config_path = "${var.config_path}"
  depends_on  = [
    "${module.monitoring_namespace.task_id}"
  ]
}

module "prometheus_service" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/prometheus/service.yaml"
  config_path = "${var.config_path}"
  depends_on  = [
    "${module.monitoring_namespace.task_id}"
  ]
}

/* ------------------------------------------------------------------------- */

module "node_exporter_daemonset" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/node-exporter/daemonset.yaml"
  config_path = "${var.config_path}"
  depends_on  = [
    "${module.monitoring_namespace.task_id}"
  ]
}

module "node_exporter_service" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/node-exporter/service.yaml"
  config_path = "${var.config_path}"
  depends_on  = [
    "${module.monitoring_namespace.task_id}"
  ]
}

/* ------------------------------------------------------------------------- */

module "kube_state_rbac" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/kube-state/rbac.yaml"
  config_path = "${var.config_path}"
  depends_on  = [
    "${module.monitoring_namespace.task_id}"
  ]
}

module "kube_state_deployment" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/kube-state/deployment.yaml"
  config_path = "${var.config_path}"
  depends_on  = [
    "${module.monitoring_namespace.task_id}"
  ]
}

module "kube_state_service" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/kube-state/service.yaml"
  config_path = "${var.config_path}"
  depends_on  = [
    "${module.monitoring_namespace.task_id}"
  ]
}

/* ------------------------------------------------------------------------- */

module "grafana_cluster_dashboard" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/grafana/configmap/cluster-dashboard.yaml"
  config_path = "${var.config_path}"
  depends_on  = [
    "${module.monitoring_namespace.task_id}"
  ]
}

module "grafana_ingress_dashboard" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/grafana/configmap/ingress-dashboard.yaml"
  config_path = "${var.config_path}"
  depends_on  = [
    "${module.monitoring_namespace.task_id}"
  ]
}

module "grafana_prometheus_source" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/grafana/configmap/prometheus-source.yaml"
  config_path = "${var.config_path}"
  depends_on  = [
    "${module.monitoring_namespace.task_id}"
  ]
}

module "grafana_volume" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/grafana/volume.yaml"
  config_path = "${var.config_path}"
  depends_on  = [
    "${module.monitoring_namespace.task_id}"
  ]
}

module "grafana_deployment" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/grafana/deployment.yaml"
  config_path = "${var.config_path}"
  depends_on  = [
    "${module.monitoring_namespace.task_id}"
  ]
}

module "grafana_service" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/grafana/service.yaml"
  config_path = "${var.config_path}"
  depends_on  = [
    "${module.monitoring_namespace.task_id}"
  ]
}

module "grafana_secret" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/grafana/secret.yaml"
  config_path = "${var.config_path}"
  depends_on  = [
    "${module.monitoring_namespace.task_id}"
  ]
}

module "grafana_job" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/grafana/job.yaml"
  config_path = "${var.config_path}"
  depends_on  = [
    "${module.monitoring_namespace.task_id}"
  ]
}

module "grafana_ingress" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/grafana/ingress.yaml"
  config_path = "${var.config_path}"
  variables   = {
    domain_name = "${var.domain_config["domain_name"]}"
  }
  depends_on  = [
    "${module.monitoring_namespace.task_id}"
  ]
}

/* ------------------------------------------------------------------------- */

module "alertmanager_configmap" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/alertmanager/configmap.yaml"
  config_path = "${var.config_path}"
  depends_on  = [
    "${module.monitoring_namespace.task_id}"
  ]
}

module "alertmanager_deployment" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/alertmanager/deployment.yaml"
  config_path = "${var.config_path}"
  depends_on  = [
    "${module.monitoring_namespace.task_id}"
  ]
}

module "alertmanager_service" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/alertmanager/service.yaml"
  config_path = "${var.config_path}"
  depends_on  = [
    "${module.monitoring_namespace.task_id}"
  ]
}