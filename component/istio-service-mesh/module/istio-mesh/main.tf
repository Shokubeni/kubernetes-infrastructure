resource "kubernetes_namespace" "istio" {
  metadata {
    name = "istio-system"
  }
}

resource "helm_release" "istio" {
  chart     = "${var.root_dir}/component/istio-service-mesh/module/istio-mesh/chart"
  namespace = "istio-system"
  name      = "istio"

  dynamic "set" {
    for_each = var.network_config.cluster_services
    content {
      name  = "publicServices[${set.key}].name"
      value = set.value.name
    }
  }

  dynamic "set" {
    for_each = var.network_config.cluster_services
    content {
      name  = "publicServices[${set.key}].ports.gateway"
      value = set.value.ports.gateway
    }
  }

  dynamic "set" {
    for_each = var.network_config.cluster_services
    content {
      name  = "publicServices[${set.key}].ports.service"
      value = set.value.ports.service
    }
  }

  depends_on = [
    kubernetes_namespace.istio,
    var.control_plane
  ]
}

data "kubernetes_service" "balancer" {
  metadata {
    name      = "istio-ingressgateway"
    namespace = "istio-system"
  }

  depends_on = [
    helm_release.istio
  ]
}