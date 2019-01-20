output "sustem_commands" {
  value = {
    kubernetes_install = "${aws_ssm_document.kubernetes.name}"
  }
}