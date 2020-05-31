resource "aws_s3_account_public_access_block" "bucket_access" {
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket" "backup" {
  bucket        = "velero-backups.${var.cluster_data.id}"
  region        = var.cluster_data.region
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

resource "kubernetes_namespace" "velero_system" {
  metadata {
    name = "velero-system"
  }
}

resource "null_resource" "velero_install" {
  provisioner "local-exec" {
    interpreter = ["/bin/sh", "-c"]
    working_dir = path.module
    command     = <<EOT
      velero install \
        --provider aws \
        --plugins velero/velero-plugin-for-aws:v1.0.1 \
        --bucket $VELERO_BUCKET \
        --backup-location-config region=$AWS_REGION \
        --snapshot-location-config region=$AWS_REGION \
        --secret-file ./velero-credentials \
        --namespace velero-system \
        --dry-run -o yaml | kubectl apply -f -
    EOT
    environment = {
      VELERO_BUCKET = aws_s3_bucket.backup.id
      AWS_REGION    = aws_s3_bucket.backup.region
    }
  }

  provisioner "local-exec" {
    interpreter = ["/bin/sh", "-c"]
    working_dir = path.module
    when        = destroy
    command     = <<EOT
      velero install \
        --provider aws \
        --plugins velero/velero-plugin-for-aws:v1.0.1 \
        --bucket $VELERO_BUCKET \
        --backup-location-config region=$AWS_REGION \
        --snapshot-location-config region=$AWS_REGION \
        --secret-file ./velero-credentials \
        --namespace velero-system \
        --dry-run -o yaml | kubectl delete -f -
    EOT
    environment = {
      VELERO_BUCKET = aws_s3_bucket.backup.id
      AWS_REGION    = aws_s3_bucket.backup.region
    }
  }

  depends_on = [
    kubernetes_namespace.velero_system
  ]
}
