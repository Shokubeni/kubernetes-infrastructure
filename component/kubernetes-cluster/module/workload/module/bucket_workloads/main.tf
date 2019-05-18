resource "aws_iam_access_key" "backup" {
  user = "${var.backup_user["id"]}"
}

data "template_file" "backup-credentials" {
  template = "${file("${path.module}/manifest/credentials")}"
  vars = {
    access_key = "${aws_iam_access_key.backup.id}"
    secret_key = "${aws_iam_access_key.backup.secret}"
  }
}

data "template_file" "backup-workload" {
  template = "${file("${path.module}/manifest/backup.yaml")}"
  vars = {
    backup_access = "${base64encode(data.template_file.backup-credentials.rendered)}"
    bucket_region = "${var.backup_bucket["region"]}"
    bucket_name   = "${var.backup_bucket["id"]}"
  }
}

resource "aws_s3_bucket_object" "backup-workload" {
  key     = "workload/backup.yaml"
  content = "${data.template_file.backup-workload.rendered}"
  bucket  = "${var.secure_bucket["id"]}"
}