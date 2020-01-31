resource "aws_iam_access_key" "velero" {
  user = var.backup_user.id
}

data "template_file" "velero-credentials" {
  template = file("${path.module}/manifest/velero/credentials")
  vars = {
    access_key = aws_iam_access_key.velero.id
    secret_key = aws_iam_access_key.velero.secret
  }
}

data "template_file" "velero-general" {
  template = file("${path.module}/manifest/velero/general.yaml")
  vars = {
    backup_access = base64encode(data.template_file.velero-credentials.rendered)
    bucket_region = var.backup_bucket.region
    bucket_name   = var.backup_bucket.id
  }
}

resource "aws_s3_bucket_object" "velero-workload" {
  key     = "workload/velero.yaml"
  content = data.template_file.velero-general.rendered
  bucket  = var.secure_bucket.id
}

resource "aws_s3_bucket_object" "linkerd-workload" {
  key     = "workload/linkerd.yaml"
  content = file("${path.module}/manifest/linkerd/general.yaml")
  bucket  = var.secure_bucket.id
}
