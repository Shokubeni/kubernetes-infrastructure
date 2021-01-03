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
    for_each = var.network_config.private_services
    content {
      name  = "privateServices[${set.key}].name"
      value = set.value.name
    }
  }

  dynamic "set" {
    for_each = var.network_config.private_services
    content {
      name  = "privateServices[${set.key}].ports.gateway"
      value = set.value.ports.gateway
    }
  }

  dynamic "set" {
    for_each = var.network_config.private_services
    content {
      name  = "privateServices[${set.key}].ports.service"
      value = set.value.ports.service
    }
  }

  dynamic "set" {
    for_each = var.network_config.public_services
    content {
      name  = "publicServices[${set.key}].name"
      value = set.value.name
    }
  }

  dynamic "set" {
    for_each = var.network_config.public_services
    content {
      name  = "publicServices[${set.key}].ports.gateway"
      value = set.value.ports.gateway
    }
  }

  dynamic "set" {
    for_each = var.network_config.public_services
    content {
      name  = "publicServices[${set.key}].ports.service"
      value = set.value.ports.service
    }
  }

  depends_on = [
    kubernetes_namespace.istio
  ]
}

data "kubernetes_service" "internal" {
  metadata {
    name      = "internal-ingressgateway"
    namespace = "istio-system"
  }

  depends_on = [
    helm_release.istio
  ]
}

data "kubernetes_service" "external" {
  metadata {
    name      = "istio-ingressgateway"
    namespace = "istio-system"
  }

  depends_on = [
    helm_release.istio
  ]
}