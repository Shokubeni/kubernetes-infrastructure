locals {
  is_master = "${contains(var.cluster_role, "controlplane") ? 0 : 1}"
}

resource "aws_lambda_function" "backup" {
  count                          = "${local.is_master}"
  function_name                  = "${var.cluster_config["label"]}-cluster-backup_${var.cluster_id}"
  source_code_hash               = "${data.archive_file.lambda_zip.output_base64sha256}"
  handler                        = "build/cluster-backup.handler"
  filename                       = "${path.module}/lambda-functions.zip"
  role                           = "${var.lambda_role_arn}"
  runtime                        = "nodejs8.10"
  reserved_concurrent_executions = 1
  timeout                        = 600

  environment {
    variables = {
      MASTER_AUTOSCALING_GROUP = "${var.cluster_config["label"]}-master_${var.cluster_id}"
      ETCD_BACKUP_COMMAND      = "${var.system_comands["cluster_etcd_backup"]}"
      S3_BUCKED_NAME           = "${var.secure_bucket_name}"
    }
  }
}

resource "aws_cloudwatch_event_rule" "backup" {
  count               = "${local.is_master}"
  name                = "${var.cluster_config["label"]}-cluster-backup_${var.cluster_id}"
  schedule_expression = "rate(2 minutes)"
}

resource "aws_cloudwatch_event_target" "backup" {
  count = "${local.is_master}"
  rule  = "${aws_cloudwatch_event_rule.backup.name}"
  arn   = "${aws_lambda_function.backup.arn}"
}

resource "aws_lambda_permission" "backup" {
  count         = "${local.is_master}"
  function_name = "${aws_lambda_function.backup.arn}"
  source_arn    = "${aws_cloudwatch_event_rule.backup.arn}"
  action        = "lambda:InvokeFunction"
  principal     = "events.amazonaws.com"
}

data "archive_file" "lambda_zip" {
  count       = "${local.is_master}"
  source_dir  = "${path.module}/lambda-functions"
  output_path = "${path.module}/lambda-functions.zip"
  type        = "zip"
}