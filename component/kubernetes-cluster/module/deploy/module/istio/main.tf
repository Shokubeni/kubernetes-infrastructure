resource "kubernetes_namespace" "istio" {
  metadata {
    labels = {
      "istio-injection" = "enabled"
    }

    name = "istio-system"
  }
}

resource "helm_release" "istio" {
  chart     = "${var.root_dir}/component/kubernetes-cluster/module/deploy/module/istio/chart"
  namespace = "istio-system"
  name      = "istio"

  depends_on = [
    kubernetes_namespace.istio
  ]
}

data "kubernetes_service" "example" {
  metadata {
    name      = "istio-ingressgateway"
    namespace = "istio-system"
  }

  depends_on = [
    helm_release.istio
  ]
}
