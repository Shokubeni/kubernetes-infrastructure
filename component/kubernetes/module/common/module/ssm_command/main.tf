resource "aws_ssm_document" "hostname" {
  name          = "${var.cluster_config["name"]}-ChangeHostname_${var.cluster_id}"
  content       = "${file("${path.module}/shell_script/change-hostname.json")}"
  document_type = "Command"
}

resource "aws_ssm_document" "docker" {
  name          = "${var.cluster_config["name"]}-DockerInstall_${var.cluster_id}"
  content       = "${file("${path.module}/shell_script/docker-install.json")}"
  document_type = "Command"
}

resource "aws_ssm_document" "kubernetes" {
  name          = "${var.cluster_config["name"]}-KubernetesInstall_${var.cluster_id}"
  content       = "${file("${path.module}/shell_script/kubernetes-install.json")}"
  document_type = "Command"
}