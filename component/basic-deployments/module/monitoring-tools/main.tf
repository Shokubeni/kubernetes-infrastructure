data "template_file" "monitoring_tools" {
  template = file("${path.module}/chart/values.yaml")

  vars = {
    //alertmanager
    alertmanager_from_adress   = "alerts@${var.network_config.domain_info.domain_name}"
    alertmanager_smtp_host     = "${var.smtp_config["host"]}:${var.smtp_config["port"]}"
    alertmanager_smtp_user     = var.smtp_config.alerts_user
    alertmanager_smtp_pass     = var.smtp_config.alerts_pass
    alertmanager_slack_channel = var.slack_channel
    alertmanager_slack_hook    = var.slack_hook
    grafana_from_adress        = "metrics@${var.network_config.domain_info.domain_name}"
    grafana_server_url         = "https://metrics.${var.network_config.domain_info.domain_name}"
    grafana_client_id          = var.grafana_client_id
    grafana_secret             = var.grafana_secret
    grafana_smtp_host          = base64encode("${var.smtp_config.host}:${var.smtp_config.port}")
    grafana_smtp_user          = base64encode(var.smtp_config.metrics_user)
    grafana_smtp_pass          = base64encode(var.smtp_config.metrics_pass)
    cluster_name               = var.cluster_config.name
    cert_issuer                = var.cluster_config.prod == true ? "prod" : "stage"
    domain_name                = var.network_config.domain_info.domain_name
    vpn_cidr                   = var.network_config.vpn_clients_cidr
  }
}

resource "kubernetes_namespace" "monitoring_tools" {
  metadata {
    annotations = {
      "linkerd.io/inject" = "enabled"
    }

    name = "monitoring-tools"
  }
}

resource "helm_release" "monitoring_tools" {
  chart     = "${var.root_dir}/component/basic-deployments/module/monitoring-tools/chart"
  name      = "monitoring-tools"
  namespace = "monitoring-tools"

  values = [
    data.template_file.monitoring_tools.rendered
  ]

  depends_on = [
    kubernetes_namespace.monitoring_tools
  ]
}
