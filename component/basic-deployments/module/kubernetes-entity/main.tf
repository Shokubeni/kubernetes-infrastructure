data "template_file" "kubernetes_entity" {
  template = "${
    length(values(var.variables)) > 0
      ? file("${var.file_path}")
      : file("${path.module}/empty.yaml")
  }"
  vars     = "${var.variables}"
}

locals {
  config_argument = "${var.config_path != "false" ? "--kubeconfig ${var.config_path}" : "" }"
  build_number    = "${
    length(values(var.variables)) > 0
      ? "${sha256("${data.template_file.kubernetes_entity.rendered}")}"
      : "${sha256(file("${var.file_path}"))}"
  }"
  file_argument   = "${
    length(values(var.variables)) > 0
      ? "-<<EOF\n${data.template_file.kubernetes_entity.rendered}\nEOF"
      : "${var.file_path}" }"
}

resource "null_resource" "kubernetes_entity" {
  triggers {
    build_number = "${local.build_number}"
  }

  provisioner "local-exec" {
    command = "kubectl ${local.config_argument} apply -f ${local.file_argument}"
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "kubectl ${local.config_argument} delete -f ${local.file_argument} && sleep ${var.delete_wait}"
  }
}