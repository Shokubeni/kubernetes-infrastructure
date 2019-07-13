resource "aws_s3_bucket" "backup" {
  bucket        = "${var.cluster_label}.backup-data.${var.cluster_id}"
  region        = var.bucket_region
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
    "Name" = "${var.cluster_name} Backup Bucket"
    "kubernetes.io/cluster/${var.cluster_id}" = "owned"
  }
}