resource "kubernetes_service" "tcp_stubs" {
  count = length(var.network_config.tcp_services)

  spec {
    external_name = "${var.network_config.tcp_services[count.index].workload}.${var.network_config.tcp_services[count.index].namespace}.svc.cluster.local"
    type = "ExternalName"
    port {
      port = var.network_config.tcp_services[count.index].port
    }
  }

  metadata {
    name = "${var.network_config.tcp_services[count.index].workload}-stub"
    namespace = "kube-system"
  }
}

resource "kubernetes_service" "udp_stubs" {
  count = length(var.network_config.udp_services)

  spec {
    external_name = "${var.network_config.udp_services[count.index].workload}.${var.network_config.udp_services[count.index].namespace}.svc.cluster.local"
    type = "ExternalName"
    port {
      port = var.network_config.udp_services[count.index].port
    }
  }

  metadata {
    name = "${var.network_config.udp_services[count.index].workload}-stub"
    namespace = "kube-system"
  }
}

data "template_file" "basic_deployments" {
  template = file("${path.module}/chart/values.yaml")

  vars = {
    //ingress controller
    ingress_tcp_services = join("\n    ", [for service in var.network_config.tcp_services : "${service.port}: ${service.namespace}/${service.workload}:${service.port}"])
    ingress_udp_services = join("\n    ", [for service in var.network_config.udp_services : "${service.port}: ${service.namespace}/${service.workload}:${service.port}"])
    iam_authentication   = templatefile("${path.module}/chart/templates/authenticator/aws-iam-users.tpl", {iam_access: var.runtime_config.iam_access})
    domain_name          = var.network_config.domain_info.domain_name
    public_zone          = var.network_config.domain_info.public_zone
    cluster_region       = var.cluster_config.region
    cluster_id           = var.cluster_config.id
  }
}

resource "helm_release" "basic_deployments" {
  chart     = "${var.root_dir}/component/basic-deployments/module/basic-deployments/chart"
  name      = "basic-deployments"
  namespace = "kube-system"

  values = [
    data.template_file.basic_deployments.rendered
  ]
}
