resource "kubernetes_namespace" "monitoring_tools" {
  metadata {
    labels = {
      "istio-injection" = "enabled"
    }

    name = "monitoring-tools"
  }
}

module "alertmanager" {
  source = "./module/alertmanager"

  chart_namespace = kubernetes_namespace.monitoring_tools.metadata[0].name
  network_config  = var.network_config
  smtp_config     = var.smtp_config
  slack_channel   = var.slack_channel
  slack_hook      = var.slack_hook
  root_dir        = var.root_dir
}

module "grafana" {
  source = "./module/grafana"

  chart_namespace   = kubernetes_namespace.monitoring_tools.metadata[0].name
  grafana_client_id = var.grafana_client_id
  grafana_secret    = var.grafana_secret
  network_config    = var.network_config
  smtp_config       = var.smtp_config
  root_dir          = var.root_dir
}

module "kube_state" {
  source = "./module/kube-state"

  chart_namespace = kubernetes_namespace.monitoring_tools.metadata[0].name
  root_dir        = var.root_dir
}

module "node_exporter" {
  source = "./module/node-exporter"

  chart_namespace = kubernetes_namespace.monitoring_tools.metadata[0].name
  root_dir        = var.root_dir
}

module "prometheus" {
  source = "./module/prometheus"

  chart_namespace = kubernetes_namespace.monitoring_tools.metadata[0].name
  root_dir        = var.root_dir
}