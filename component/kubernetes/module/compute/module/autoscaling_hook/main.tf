locals {
  lambda_function = "${
    contains(var.cluster_role, "controlplane")
        ? "master_initialize"
        : "worker_initialize"
  }"
  role_postfix   = "${
    contains(var.cluster_role, "controlplane")
        ? "master-lifecycle"
        : "worker-lifecycle"
  }"
}

data "archive_file" "lambda_zip" {
  source_dir  = "${path.module}/${local.lambda_function}"
  output_path = "${path.module}/${local.lambda_function}.zip"
  type        = "zip"
}

resource "aws_lambda_function" "lifecycle" {
  function_name    = "${var.cluster_config["label"]}-${local.role_postfix}_${var.cluster_id}"
  source_code_hash = "${data.archive_file.lambda_zip.output_base64sha256}"
  filename         = "${path.module}/${local.lambda_function}.zip"
  role             = "${var.lambda_role_arn}"
  handler          = "index.handler"
  runtime          = "nodejs8.10"

  environment {
    variables = {
      KUBERNETES_INSTALL_COMMAND = "${var.system_comands["kubernetes_install"]}"
    }
  }
}

resource "aws_sns_topic" "lifecycle" {
  name = "${var.cluster_config["label"]}-${local.role_postfix}_${var.cluster_id}"
}

resource "aws_sns_topic_subscription" "lifecycle" {
  endpoint  = "${aws_lambda_function.lifecycle.arn}"
  topic_arn = "${aws_sns_topic.lifecycle.arn}"
  protocol  = "lambda"
}

resource "aws_lambda_permission" "lifecycle" {
  function_name  = "${aws_lambda_function.lifecycle.function_name}"
  source_arn     = "${aws_sns_topic.lifecycle.arn}"
  action         = "lambda:InvokeFunction"
  principal      = "sns.amazonaws.com"
}