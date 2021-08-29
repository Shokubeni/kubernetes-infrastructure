resource "helm_release" "kiali" {
  chart     = "${var.root_dir}/component/basic-deployments/module/kiali-service-mesh/chart"
  namespace = "istio-system"
  name      = "kiali"
}
