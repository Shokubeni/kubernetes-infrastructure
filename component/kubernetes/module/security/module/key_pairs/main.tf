locals {
  unique_hash = "${substr(sha512(timestamp()), 0, 5)}"
}

resource "tls_private_key" "master" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "aws_key_pair" "master" {
  key_name   = "${var.cluster_config["label"]}-master-${local.unique_hash}"
  public_key = "${tls_private_key.master.public_key_openssh}"
}

resource "tls_private_key" "worker" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "aws_key_pair" "worker" {
  key_name   = "${var.cluster_config["label"]}-worker-${local.unique_hash}"
  public_key = "${tls_private_key.worker.public_key_openssh}"
}