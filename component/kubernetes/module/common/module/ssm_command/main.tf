data "template_file" "kubernetes" {
  template = "${file("${path.module}/shell_script/kubernetes-install.json")}"

  vars {
    commands = "${file("${path.module}/shell_script/kubernetes-install.sh")}"
  }
}

resource "aws_ssm_document" "kubernetes" {
  name          = "${var.cluster_config["name"]}-KubernetesInstall_${var.cluster_id}"
  content       = "${data.template_file.kubernetes.rendered}"
  document_type = "Command"
}