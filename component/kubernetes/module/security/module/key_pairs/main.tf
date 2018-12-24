resource "tls_private_key" "master" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "tls_private_key" "worker" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "aws_key_pair" "master" {
  key_name   = "${terraform.workspace}-master-node"
  public_key = "${tls_private_key.master.public_key_openssh}"
}

resource "aws_key_pair" "worker" {
  key_name   = "${terraform.workspace}-worker-node"
  public_key = "${tls_private_key.worker.public_key_openssh}"
}