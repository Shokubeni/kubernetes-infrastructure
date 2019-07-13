module "bucket_workloads" {
  source = "./module/bucket_workloads"

  secure_bucket = var.secure_bucket
  backup_bucket = var.backup_bucket
  backup_user   = var.backup_user
}