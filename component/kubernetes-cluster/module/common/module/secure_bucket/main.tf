resource "aws_s3_bucket" "bucket" {
  bucket        = "kubernetes-cluster.cluster-data.${var.cluster_id}"
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

  lifecycle_rule {
    id      = "commands"
    prefix  = "commands/"
    enabled = true

    expiration {
      days = 1
    }
  }

  tags = {
    "Name" = "${var.cluster_name} Cluster Bucket"
    "kubernetes.io/cluster/${var.cluster_id}" = "owned",
 }
}
