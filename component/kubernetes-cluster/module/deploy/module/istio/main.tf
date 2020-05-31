resource "kubernetes_namespace" "istio_system" {
  metadata {
    name = "istio-system"
  }
}

data "template_file" "istio_config" {
  template = "${var.root_dir}/component/kubernetes-cluster/module/deploy/istio-system/config.yaml"
}

resource "null_resource" "istio_install" {
  provisioner "local-exec" {
    command     = "istioctl manifest generate -f istio-system/config.yaml | kubectl apply -f -"
    interpreter = ["/bin/sh", "-c"]
    working_dir = path.module
  }

  provisioner "local-exec" {
    command     = "istioctl manifest generate -f istio-system/config.ysml | kubectl delete -f -"
    interpreter = ["/bin/sh", "-c"]
    working_dir = path.module
    when        = destroy
  }

  triggers = {
    config = data.template_file.istio_config.rendered
  }

  depends_on = [
    kubernetes_namespace.istio_system
  ]
}