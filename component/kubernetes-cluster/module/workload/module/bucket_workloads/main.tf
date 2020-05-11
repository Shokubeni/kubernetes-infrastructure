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

resource "aws_s3_bucket_object" "velero-crd-list" {
  key     = "workload/velero-crd-list.yaml"
  content = file("${path.module}/manifest/velero/crd-list.yaml")
  bucket  = var.secure_bucket.id
}

resource "aws_s3_bucket_object" "velero-general" {
  key     = "workload/velero-general.yaml"
  content = data.template_file.velero-general.rendered
  bucket  = var.secure_bucket.id
}

resource "aws_s3_bucket_object" "linkerd-crd-list" {
  key     = "workload/linkerd-crd-list.yaml"
  content = file("${path.module}/manifest/linkerd/crd-list.yaml")
  bucket  = var.secure_bucket.id
}

resource "aws_s3_bucket_object" "linkerd-general" {
  key     = "workload/linkerd-general.yaml"
  content = file("${path.module}/manifest/linkerd/general.yaml")
  bucket  = var.secure_bucket.id
}
