resource "aws_ssm_document" "node_runtime" {
  name          = "${var.cluster_name}-NodeRuntimeInstall_${var.cluster_id}"
  content       = "${file("${path.module}/shell_script/runtime-installation.json")}"
  document_type = "Command"
}

resource "aws_ssm_document" "general_master" {
  name          = "${var.cluster_name}-GeneralMasterInit_${var.cluster_id}"
  content       = "${file("${path.module}/shell_script/general-master-init.json")}"
  document_type = "Command"
}

resource "aws_ssm_document" "general_restore" {
  name          = "${var.cluster_name}-GeneralMasterRestore_${var.cluster_id}"
  content       = "${file("${path.module}/shell_script/general-master-restore.json")}"
  document_type = "Command"
}

resource "aws_ssm_document" "stacked_master" {
  name          = "${var.cluster_name}-StackedMasterInit_${var.cluster_id}"
  content       = "${file("${path.module}/shell_script/stacked-master-init.json")}"
  document_type = "Command"
}

resource "aws_ssm_document" "common_worker" {
  name          = "${var.cluster_name}-CommonWorkerInit_${var.cluster_id}"
  content       = "${file("${path.module}/shell_script/common-worker-init.json")}"
  document_type = "Command"
}

resource "aws_ssm_document" "cluster_backup" {
  name          = "${var.cluster_name}-ClusterEtcdBackup_${var.cluster_id}"
  content       = "${file("${path.module}/shell_script/cluster-etcd-backup.json")}"
  document_type = "Command"
}

resource "aws_ssm_document" "renew_token" {
  name          = "${var.cluster_name}-RenewJoinToken_${var.cluster_id}"
  content       = "${file("${path.module}/shell_script/renew-join-token.json")}"
  document_type = "Command"
}