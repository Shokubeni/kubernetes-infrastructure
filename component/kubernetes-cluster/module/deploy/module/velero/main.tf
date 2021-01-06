resource "aws_s3_account_public_access_block" "bucket_access" {
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket" "backup" {
  bucket        = "velero-backups.${var.cluster_data.id}"
  acl           = "private"
  force_destroy = true

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    "Name" = "${var.cluster_data.name} Backup Bucket"
    "kubernetes.io/cluster/${var.cluster_data.id}" = "owned"
  }
}

data "aws_iam_policy_document" "velero_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(var.openid_provider.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:velero"]
    }

    principals {
      identifiers = [var.openid_provider.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "velero" {
  name               = "${var.cluster_data.name}VeleroBackup_${var.cluster_data.id}"
  assume_role_policy = data.aws_iam_policy_document.velero_assume_role.json
  description        = "Provides appropriate rights for Velero cluster deployment"
}

data "template_file" "velero" {
  template = file("${path.module}/policy/backup.json")

  vars = {
    backup_bucket = aws_s3_bucket.backup.id
  }
}

resource "aws_iam_role_policy" "velero_backup_policy" {
  policy = data.template_file.velero.rendered
  role   = aws_iam_role.velero.id
  name   = "ClusterBackupPolicy"
}

resource "helm_release" "velero" {
  chart     = "${var.root_dir}/component/kubernetes-cluster/module/deploy/module/velero/chart"
  namespace = "kube-system"
  name      = "velero"

  set {
    name  = "bucketRegion"
    value = aws_s3_bucket.backup.region
  }

  set {
    name  = "bucketName"
    value = aws_s3_bucket.backup.id
  }

  set {
    name  = "roleArn"
    value = aws_iam_role.velero.arn
  }

  dynamic "set" {
    for_each = var.runtime_config.backups
    content {
      name  = "backups[${set.key}].name"
      value = set.value.name
    }
  }

  dynamic "set" {
    for_each = var.runtime_config.backups
    content {
      name  = "backups[${set.key}].schedule"
      value = set.value.schedule
    }
  }

  dynamic "set" {
    for_each = var.runtime_config.backups
    content {
      name  = "backups[${set.key}].lifetime"
      value = set.value.lifetime
    }
  }

  dynamic "set" {
    for_each = var.runtime_config.backups
    content {
      name  = "backups[${set.key}].includeNamespaces"
      value = "{${join(",",set.value.include.namespaces)}}"
    }
  }

  dynamic "set" {
    for_each = var.runtime_config.backups
    content {
      name  = "backups[${set.key}].includeResources"
      value = "{${join(",",set.value.include.resources)}}"
    }
  }

  dynamic "set" {
    for_each = var.runtime_config.backups
    content {
      name  = "backups[${set.key}].excludeNamespaces"
      value = "{${join(",",set.value.exclude.namespaces)}}"
    }
  }

  dynamic "set" {
    for_each = var.runtime_config.backups
    content {
      name  = "backups[${set.key}].exclude.resources"
      value = "{${join(",",set.value.exclude.resources)}}"
    }
  }

  depends_on = [
    aws_s3_bucket.backup,
    aws_iam_role.velero,
    var.control_plane
  ]
}
