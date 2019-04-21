provider "kubernetes" {
  config_path = "${var.config_path}"
}

resource "null_resource" "ingress" {
  triggers {
    build_number = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "kubectl --kubeconfig ${var.config_path} apply -f ${path.module}/workload/ingress-controller.yaml"
  }
}

resource "null_resource" "lego" {
  triggers {
    build_number = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "kubectl --kubeconfig ${var.config_path} apply -f ${path.module}/workload/kube-lego.yaml"
  }
}