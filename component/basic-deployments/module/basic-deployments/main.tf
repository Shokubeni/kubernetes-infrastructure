data "template_file" "basic_deployments" {
  template = file("${path.module}/chart/values.yaml")

  vars = {
    //ingress controller
    ingress_tcp_services = join("\n    ", [for port, service in var.network_config.tcp_services : "${port}: ${service}"])
    ingress_udp_services = join("\n    ", [for port, service in var.network_config.udp_services : "${port}: ${service}"])
    domain_name          = var.network_config.domain_info.domain_name
    cluster_id           = var.cluster_config.id
    auth_admin_role      = var.admin_role
  }
}

resource "helm_release" "basic_deployments" {
  chart     = "${path.module}/chart"
  name      = "basic-deployments"
  namespace = "kube-system"
  version   = "1.0.0"

  values = [
    data.template_file.basic_deployments.rendered
  ]
}
