resource "aws_iam_role" "backup" {
  name               = "${var.cluster_config["name"]}ClusterBackup_${var.cluster_config["id"]}"
  description        = "Enables AWS Backup service access to cluster volumes"
  assume_role_policy = "${file("${path.module}/assume-policy.json")}"
}

resource "aws_iam_role_policy_attachment" "backup" {
  role       = "${aws_iam_role.backup.id}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}

resource "aws_iam_role_policy_attachment" "restore" {
  role       = "${aws_iam_role.backup.id}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores"
}