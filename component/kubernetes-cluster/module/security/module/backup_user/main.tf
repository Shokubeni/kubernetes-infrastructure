data "template_file" "backup" {
  template = "${file("${path.module}/backup-policy.json")}"

  vars {
    bucket_name = "${var.bucket_name}"
  }
}

resource "aws_iam_user" "backup" {
  name = "ClusterBackup.${var.cluster_config["id"]}"
  path = "/cluster/"
}

resource "aws_iam_user_policy" "backup" {
  name   = "ClusterBackupPolicy"
  user   = "${aws_iam_user.backup.id}"
  policy = "${data.template_file.backup.rendered}"
}