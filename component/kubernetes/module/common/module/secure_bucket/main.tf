resource "aws_s3_bucket" "bucket" {
  bucket        = "${var.cluster_config["label"]}.${var.cluster_id}"
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
    id      = "command"
    prefix  = "command/"
    enabled = true

    expiration {
      days = 1
    }
  }

  tags = "${merge(
    map(
      "Name", "${var.cluster_config["name"]} Cluster Bucket",
      "kubernetes.io/cluster/${var.cluster_id}", "owned"
    )
  )}"
}