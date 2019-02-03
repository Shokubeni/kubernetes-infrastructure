resource "aws_ssm_document" "docker" {
  name          = "${var.cluster_config["name"]}-DockerInstall_${var.cluster_id}"
  content       = "${file("${path.module}/shell_script/docker-install.json")}"
  document_type = "Command"
}