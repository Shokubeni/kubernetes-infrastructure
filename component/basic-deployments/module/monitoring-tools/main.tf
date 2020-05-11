resource "kubernetes_namespace" "monitoring_tools" {
  metadata {
    annotations = {
      "linkerd.io/inject" = "enabled"
    }

    name = "monitoring-tools"
  }
}

data "template_file" "alertmanager" {
  template = file("${path.module}/charts/alertmanager/values.yaml")

  vars = {
    from_adress   = "alerts@${var.network_config.domain_info.domain_name}"
    smtp_host     = "${var.smtp_config["host"]}:${var.smtp_config["port"]}"
    smtp_user     = var.smtp_config.alerts_user
    smtp_pass     = var.smtp_config.alerts_pass
    slack_channel = var.slack_channel
    slack_hook    = var.slack_hook
  }
}

resource "helm_release" "alertmanager" {
  chart        = "${var.root_dir}/component/basic-deployments/module/monitoring-tools/charts/alertmanager"
  name         = "alertmanager"
  namespace    = "monitoring-tools"

  values = [
    data.template_file.alertmanager.rendered
  ]

  depends_on = [
    kubernetes_namespace.monitoring_tools
  ]
}

data "template_file" "grafana" {
  template = file("${path.module}/charts/grafana/values.yaml")

  vars = {
    from_adress = "metrics@${var.network_config.domain_info.domain_name}"
    server_url  = "https://metrics.${var.network_config.domain_info.domain_name}"
    client_id   = var.grafana_client_id
    secret      = var.grafana_secret
    smtp_host   = base64encode("${var.smtp_config.host}:${var.smtp_config.port}")
    smtp_user   = base64encode(var.smtp_config.metrics_user)
    smtp_pass   = base64encode(var.smtp_config.metrics_pass)
    cert_issuer = var.cluster_config.prod == true ? "prod" : "stage"
    domain_name = var.network_config.domain_info.domain_name
    vpn_cidr    = var.network_config.vpn_clients_cidr
  }
}

resource "helm_release" "grafana" {
  chart        = "${var.root_dir}/component/basic-deployments/module/monitoring-tools/charts/grafana"
  name         = "grafana"
  namespace    = "monitoring-tools"

  values = [
    data.template_file.grafana.rendered
  ]

  depends_on = [
    kubernetes_namespace.monitoring_tools
  ]
}

resource "helm_release" "kube_state" {
  chart        = "${var.root_dir}/component/basic-deployments/module/monitoring-tools/charts/kube-state"
  name         = "kube-state"
  namespace    = "monitoring-tools"

  depends_on = [
    kubernetes_namespace.monitoring_tools
  ]
}

resource "helm_release" "node_exporter" {
  chart        = "${var.root_dir}/component/basic-deployments/module/monitoring-tools/charts/node-exporter"
  name         = "node-exporter"
  namespace    = "monitoring-tools"

  depends_on = [
    kubernetes_namespace.monitoring_tools
  ]
}

resource "helm_release" "prometheus" {
  chart        = "${var.root_dir}/component/basic-deployments/module/monitoring-tools/charts/prometheus"
  name         = "prometheus"
  namespace    = "monitoring-tools"

  depends_on = [
    kubernetes_namespace.monitoring_tools
  ]
}
