locals {
  config_argument = "${var.config_path != "null" ? "--kubeconfig ${var.config_path}" : "" }"
}

resource "null_resource" "dependency_getter" {
  provisioner "local-exec" {
    command = "echo ${length(var.depends_on)}"
  }
}

data "template_file" "kubernetes_object" {
  depends_on = ["null_resource.dependency_getter"]

  template = "${
    length(values(var.variables)) > 0 ? file("${var.file_path}") : file("${path.module}/empty.yaml")
  }"
  vars     = "${var.variables}"
}

resource "null_resource" "kubernetes_object" {
  depends_on = ["null_resource.dependency_getter"]

  triggers {
    build_number = "${sha256(file("${var.file_path}"))}:${sha256(join(",", values(var.variables)))}"
  }

  provisioner "local-exec" {
    command = "kubectl ${local.config_argument} apply -f ${
      length(values(var.variables)) > 0
        ? "-<<EOF\n${data.template_file.kubernetes_object.rendered}\nEOF"
        : "${var.file_path}"
    }"
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "kubectl ${local.config_argument} delete -f ${var.file_path} && sleep ${var.delay_time}"
  }
}

resource "null_resource" "dependency_setter" {
  depends_on = [
    "null_resource.kubernetes_object"
  ]
}