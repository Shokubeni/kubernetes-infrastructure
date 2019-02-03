output "sustem_commands" {
  value = {
    docker_install = "${aws_ssm_document.docker.name}"
  }
}