data "template_file" "backup" {
  template = file("${path.module}/policy/backup.json")

  vars = {
    backup_bucket = var.bucket_data.name
  }
}

resource "aws_iam_user" "backup" {
  name = "Velero.${var.cluster_data.id}"
  path = "/cluster/"
}

resource "aws_iam_user_policy" "backup" {
  name   = "ClusterBackupPolicy"
  user   = aws_iam_user.backup.id
  policy = data.template_file.backup.rendered
}
