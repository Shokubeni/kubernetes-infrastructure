resource "kubernetes_namespace" "monitoring_tools" {
  metadata {
    labels = {
      "istio-injection" = "enabled"
    }

    name = "monitoring-tools"
  }
}

resource "helm_release" "alertmanager" {
  chart     = "${var.root_dir}/component/basic-deployments/module/monitoring-tools/charts/alertmanager"
  name      = "alertmanager"
  namespace = "monitoring-tools"

  set {
    name  = "smtp.from"
    value = "alerts@${var.network_config.domain_info.domain_name}"
  }

  set {
    name  = "smtp.host"
    value = "${var.smtp_config["host"]}:${var.smtp_config["port"]}"
  }

  set {
    name  = "smtp.user"
    value = var.smtp_config.alerts_user
  }

  set {
    name  = "smtp.pass"
    value = var.smtp_config.alerts_pass
  }

  set {
    name  = "slack.channel"
    value = var.slack_channel
  }

  set {
    name  = "slack.hook"
    value = var.slack_hook
  }

  depends_on = [
    kubernetes_namespace.monitoring_tools
  ]
}

resource "helm_release" "grafana" {
  chart     = "${var.root_dir}/component/basic-deployments/module/monitoring-tools/charts/grafana"
  name      = "grafana"
  namespace = "monitoring-tools"

  set {
    name  = "domainName"
    value = var.network_config.domain_info.domain_name
  }

  set {
    name  = "serverUrl"
    value = "https://metrics.${var.network_config.domain_info.domain_name}"
  }

  set {
    name  = "vpnCidr"
    value = var.network_config.vpn_clients_cidr
  }

  set {
    name  = "auth.clientId"
    value = var.grafana_client_id
  }

  set {
    name  = "auth.secret"
    value = var.grafana_secret
  }

  set {
    name  = "smtp.from"
    value = "metrics@${var.network_config.domain_info.domain_name}"
  }

  set {
    name  = "smtp.host"
    value = base64encode("${var.smtp_config.host}:${var.smtp_config.port}")
  }

  set {
    name  = "smtp.user"
    value = base64encode(var.smtp_config.metrics_user)
  }

  set {
    name  = "smtp.pass"
    value = base64encode(var.smtp_config.metrics_pass)
  }

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
