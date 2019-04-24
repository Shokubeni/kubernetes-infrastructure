locals {
  public_subnets  = "${split(",", var.network_data["public_subnet_ids"])}"
}

resource "aws_security_group" "efs" {
  name   = "${var.cluster_config["label"]}-efs_${var.cluster_config["id"]}"
  vpc_id = "${var.network_data["virtual_cloud_id"]}"

  ingress {
    description = "Allows NFS traffic"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["${var.virtual_cloud_cidr}"]
  }

  egress {
    description = "Allows NFS traffic"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["${var.virtual_cloud_cidr}"]
  }

  tags = "${merge(
    map(
      "Name", "${var.cluster_config["name"]} Network Filesystem",
      "kubernetes.io/cluster/${var.cluster_config["id"]}", "owned"
    )
  )}"
}

resource "aws_efs_file_system" "efs" {
  creation_token = "${var.cluster_config["label"]}.${var.cluster_config["id"]}"

  tags = "${merge(
    map(
      "Name", "${var.cluster_config["name"]} Cluster Filesystem",
      "kubernetes.io/cluster/${var.cluster_config["id"]}", "owned"
    )
  )}"
}

resource "aws_efs_mount_target" "efs" {
  count = "${length(local.public_subnets)}"

  subnet_id       = "${element(local.public_subnets, count.index)}"
  file_system_id  = "${aws_efs_file_system.efs.id}"
  security_groups = ["${aws_security_group.efs.id}"]
}

data "template_file" "efs" {
  depends_on = ["aws_efs_mount_target.efs"]
  template   = "${file("${path.module}/template/efs-provisioner.yaml")}"

  vars {
    filesystem_dns = "${aws_efs_file_system.efs.dns_name}"
    filesystem_id  = "${aws_efs_file_system.efs.id}"
    domain_name    = "${var.domain_config["domain_name"]}"
    cluster_region = "${var.cluster_config["region"]}"
  }
}

resource "null_resource" "efs" {
  depends_on = ["aws_efs_mount_target.efs"]
  triggers = {
    manifest_sha1 = "${sha1("${data.template_file.efs.rendered}")}"
  }

  provisioner "local-exec" {
    command = "kubectl --kubeconfig ${var.config_path} apply -f -<<EOF\n${data.template_file.efs.rendered}\nEOF"
  }
}
