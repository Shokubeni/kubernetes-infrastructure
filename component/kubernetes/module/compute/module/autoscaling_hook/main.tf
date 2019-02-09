locals {
  lambda_function = "${
    contains(var.cluster_role, "controlplane")
        ? "master_initialize"
        : "worker_initialize"
  }"
  role_postfix    = "${
    contains(var.cluster_role, "controlplane")
        ? "master-lifecycle"
        : "worker-lifecycle"
  }"
  role_name       = "${
    contains(var.cluster_role, "controlplane")
        ? "Master"
        : "Worker"
  }"
  concurency      = "${
    contains(var.cluster_role, "controlplane")
        ? 1
        : 0

  }"
}

resource "aws_lambda_function" "lifecycle" {
  function_name                  = "${var.cluster_config["label"]}-${local.role_postfix}_${var.cluster_id}"
  source_code_hash               = "${data.archive_file.lambda_zip.output_base64sha256}"
  filename                       = "${path.module}/${local.lambda_function}.zip"
  role                           = "${var.lambda_role_arn}"
  handler                        = "index.handler"
  runtime                        = "nodejs8.10"
  reserved_concurrent_executions = "${local.concurency}"
  timeout                        = 90

  environment {
    variables = {
      CHANGE_HOSTNAME_COMMAND    = "${var.system_comands["change_hostname"]}"
      KUBERNETES_INSTALL_COMMAND = "${var.system_comands["kubernetes_install"]}"
      DOCKER_INSTALL_COMMAND     = "${var.system_comands["docker_install"]}"
      SQS_QUEUE_URL              = "${aws_sqs_queue.lifecycle.id}"
    }
  }
}

resource "aws_sqs_queue" "lifecycle" {
  name                       = "${var.cluster_config["label"]}-${local.role_postfix}_${var.cluster_id}"
  message_retention_seconds  = 420
  visibility_timeout_seconds = 90
  delay_seconds              = 90

  tags = "${merge(
    map(
      "Name", "${var.cluster_config["name"]} ${local.role_name} Lifecycle",
      "kubernetes.io/cluster/${var.cluster_id}", "owned"
    )
  )}"
}

resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  function_name     = "${aws_lambda_function.lifecycle.function_name}"
  event_source_arn  = "${aws_sqs_queue.lifecycle.arn}"
  enabled           = true
  batch_size        = 1
}

resource "aws_lambda_permission" "lifecycle" {
  function_name  = "${aws_lambda_function.lifecycle.function_name}"
  source_arn     = "${aws_sqs_queue.lifecycle.arn}"
  action         = "lambda:InvokeFunction"
  principal      = "sqs.amazonaws.com"
}

data "archive_file" "lambda_zip" {
  source_dir  = "${path.module}/${local.lambda_function}"
  output_path = "${path.module}/${local.lambda_function}.zip"
  type        = "zip"
}