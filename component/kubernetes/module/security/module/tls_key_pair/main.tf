resource "tls_private_key" "master" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "aws_key_pair" "master" {
  key_name   = "${var.cluster_config["label"]}-master_${var.cluster_id}"
  public_key = "${tls_private_key.master.public_key_openssh}"
}

resource "tls_private_key" "worker" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "aws_key_pair" "worker" {
  key_name   = "${var.cluster_config["label"]}-worker_${var.cluster_id}"
  public_key = "${tls_private_key.worker.public_key_openssh}"
}