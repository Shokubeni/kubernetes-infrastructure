output "sustem_commands" {
  value = {
    change_hostname    = "${aws_ssm_document.hostname.name}"
    docker_install     = "${aws_ssm_document.docker.name}"
    kubernetes_install = "${aws_ssm_document.kubernetes.name}"
  }
}