resource "aws_s3_bucket" "bucket" {
  bucket        = "${var.cluster_label}.${var.cluster_id}"
  region        = "${var.bucket_region}"
  acl           = "private"
  force_destroy = true

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule {
    id      = "commands"
    prefix  = "commands/"
    enabled = true

    expiration {
      days = 1
    }
  }

  lifecycle_rule {
    id      = "snapshots"
    prefix  = "snapshots/"
    enabled = false

    expiration {
      days = 1
    }
  }


  tags = "${merge(
    map(
      "Name", "${var.cluster_name} Cluster Bucket",
      "kubernetes.io/cluster/${var.cluster_id}", "owned"
    )
  )}"
}