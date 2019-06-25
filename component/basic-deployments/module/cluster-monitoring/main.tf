module "monitoring_namespace" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/namespace.yaml"
  config_path = var.config_path
}

/* ------------------------------------------------------------------------- */

module "alertmanager_configmap" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/alertmanager/configmap.yaml"
  config_path = var.config_path
  variables   = {
    from_adress   = "alerts@${var.network_config.domain_info.domain_name}"
    smtp_host     = "${var.smtp_config["host"]}:${var.smtp_config["port"]}"
    smtp_user     = var.smtp_config.alerts_user
    smtp_pass     = var.smtp_config.alerts_pass
    slack_channel = var.slack_channel
    slack_hook    = var.slack_hook
  }
  depends     = [
    module.monitoring_namespace.task_id
  ]
}

module "alertmanager_deployment" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/alertmanager/deployment.yaml"
  config_path = var.config_path
  depends     = [
    module.monitoring_namespace.task_id
  ]
}

module "alertmanager_service" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/alertmanager/service.yaml"
  config_path = var.config_path
  depends     = [
    module.monitoring_namespace.task_id
  ]
}

/* ------------------------------------------------------------------------- */

module "node_exporter_daemonset" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/node-exporter/daemonset.yaml"
  config_path = var.config_path
  depends     = [
    module.monitoring_namespace.task_id
  ]
}

module "node_exporter_service" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/node-exporter/service.yaml"
  config_path = var.config_path
  depends     = [
    module.monitoring_namespace.task_id
  ]
}

/* ------------------------------------------------------------------------- */

module "kube_state_rbac" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/kube-state/rbac.yaml"
  config_path = var.config_path
  depends     = [
    module.monitoring_namespace.task_id
  ]
}

module "kube_state_deployment" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/kube-state/deployment.yaml"
  config_path = var.config_path
  depends     = [
    module.monitoring_namespace.task_id
  ]
}

module "kube_state_service" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/kube-state/service.yaml"
  config_path = var.config_path
  depends     = [
    module.monitoring_namespace.task_id
  ]
}

/* ------------------------------------------------------------------------- */

module "prometheus_rbac" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/prometheus/rbac.yaml"
  config_path = var.config_path
  depends     = [
    module.monitoring_namespace.task_id
  ]
}

module "prometheus_configmap" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/prometheus/configmap.yaml"
  config_path = var.config_path
  depends     = [
    module.monitoring_namespace.task_id
  ]
}

module "prometheus_volume" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/prometheus/volume.yaml"
  config_path = var.config_path
  depends     = [
    module.monitoring_namespace.task_id
  ]
}

module "prometheus_deployment" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/prometheus/deployment.yaml"
  config_path = var.config_path
  depends     = [
    module.monitoring_namespace.task_id
  ]
}

module "prometheus_service" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/prometheus/service.yaml"
  config_path = var.config_path
  depends     = [
    module.monitoring_namespace.task_id
  ]
}

/* ------------------------------------------------------------------------- */

module "grafana_cluster_dashboard" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/grafana/configmap/cluster-dashboard.yaml"
  config_path = var.config_path
  depends     = [
    module.monitoring_namespace.task_id
  ]
}

module "grafana_ingress_dashboard" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/grafana/configmap/ingress-dashboard.yaml"
  config_path = var.config_path
  depends     = [
    module.monitoring_namespace.task_id
  ]
}

module "linkerd_dashboard_1" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/grafana/configmap/linkerd-dashboard_1.yaml"
  config_path = var.config_path
  depends     = [
    module.monitoring_namespace.task_id
  ]
}

module "linkerd_dashboard_2" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/grafana/configmap/linkerd-dashboard_2.yaml"
  config_path = var.config_path
  depends     = [
    module.monitoring_namespace.task_id
  ]
}

module "linkerd_dashboard_3" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/grafana/configmap/linkerd-dashboard_3.yaml"
  config_path = var.config_path
  depends     = [
    module.monitoring_namespace.task_id
  ]
}

module "grafana_general_config" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/grafana/configmap/grafana-configmap.yaml"
  config_path = var.config_path
  variables   = {
    from_adress       = "metrics@${var.network_config.domain_info.domain_name}"
    server_url        = "https://metrics.${var.network_config.domain_info.domain_name}"
    domain_name       = var.network_config.domain_info.domain_name
    cluster_name      = var.cluster_config.name
    okta_url          = var.okta_url
    grafana_client_id = var.grafana_client_id
    grafana_secret    = var.grafana_secret
  }
  depends     = [
    module.monitoring_namespace.task_id
  ]
}

module "grafana_volume" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/grafana/volume.yaml"
  config_path = var.config_path
  depends     = [
    module.monitoring_namespace.task_id
  ]
}

module "grafana_deployment" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/grafana/deployment.yaml"
  config_path = var.config_path
  depends     = [
    module.monitoring_namespace.task_id
  ]
}

module "grafana_service" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/grafana/service.yaml"
  config_path = var.config_path
  depends     = [
    module.monitoring_namespace.task_id
  ]
}

module "grafana_secret" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/grafana/secret.yaml"
  config_path = var.config_path
  variables   = {
    smtp_host = base64encode("${var.smtp_config.host}:${var.smtp_config.port}")
    smtp_user = base64encode(var.smtp_config.metrics_user)
    smtp_pass = base64encode(var.smtp_config.metrics_pass)
  }
  depends     = [
    module.monitoring_namespace.task_id
  ]
}

module "grafana_ingress" {
  source = "../kubernetes-object"

  file_path   = "${path.module}/manifest/grafana/ingress.yaml"
  config_path = var.config_path
  variables   = {
    domain_name = var.network_config.domain_info.domain_name
  }
  depends     = [
    module.monitoring_namespace.task_id
  ]
}