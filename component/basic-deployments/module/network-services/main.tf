resource "kubernetes_namespace" "network_services" {
  metadata {
    annotations = {
      "linkerd.io/inject" = "enabled"
    }

    name = "network-services"
  }
}

data "template_file" "ingress_nginx" {
  template = file("${path.module}/charts/ingress-nginx/values.yaml")

  vars = {
    ingress_tcp_services = join("\n  ", [for service in var.network_config.tcp_services : "${service.port}: ${service.namespace}/${service.workload}:${service.port}"])
    ingress_udp_services = join("\n  ", [for service in var.network_config.udp_services : "${service.port}: ${service.namespace}/${service.workload}:${service.port}"])
  }
}

resource "helm_release" "ingress_nginx" {
  chart     = "${var.root_dir}/component/basic-deployments/module/network-services/charts/ingress-nginx"
  name      = "ingress-nginx"
  namespace = "network-services"

  values = [
    data.template_file.ingress_nginx.rendered
  ]

  depends_on = [
    kubernetes_namespace.network_services
  ]
}

resource "helm_release" "open_vpn" {
  chart     = "${var.root_dir}/component/basic-deployments/module/network-services/charts/open-vpn"
  name      = "open-vpn"
  namespace = "network-services"

  depends_on = [
    kubernetes_namespace.network_services
  ]
}
