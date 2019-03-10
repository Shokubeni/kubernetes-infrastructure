locals {
  lambda_function = "${
    contains(var.cluster_role, "controlplane")
        ? "master-initialize"
        : "worker-initialize"
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
        : 5

  }"
}

resource "aws_lambda_function" "lifecycle" {
  function_name                  = "${var.cluster_config["label"]}-${local.role_postfix}_${var.cluster_id}"
  source_code_hash               = "${data.archive_file.lambda_zip.output_base64sha256}"
  handler                        = "build/${local.lambda_function}.handler"
  filename                       = "${path.module}/lambda-functions.zip"
  role                           = "${var.lambda_role_arn}"
  runtime                        = "nodejs8.10"
  reserved_concurrent_executions = "${local.concurency}"
  timeout                        = 360

  environment {
    variables = {
      NODE_RUNTIME_INSTALL_COMMAND = "${var.system_comands["node_runtime_install"]}"
      GENERAL_MASTER_INIT_COMMAND  = "${var.system_comands["general_master_init"]}"
      STACKED_MASTER_INIT_COMMAND  = "${var.system_comands["stacked_master_init"]}"
      COMMON_WORKER_INIT_COMMAND   = "${var.system_comands["common_worker_init"]}"
      MASTER_AUTOSCALING_GROUP     = "${var.cluster_config["label"]}-master_${var.cluster_id}"
      WORKER_AUTOSCALING_GROUP     = "${var.cluster_config["label"]}-worker_${var.cluster_id}"
      KUBERNETES_VERSION           = "${var.cluster_config["kubernetes"]}"
      DOCKER_VERSION               = "${var.cluster_config["docker"]}"
      LOAD_BALANCER_DNS            = "${var.load_balancer_dns}"
      S3_BUCKED_NAME               = "${var.secure_bucket_name}"
      SQS_QUEUE_URL                = "${aws_sqs_queue.lifecycle.id}"
      CLUSTER_ID                   = "${var.cluster_id}"
    }
  }
}

resource "aws_sqs_queue" "lifecycle" {
  name                       = "${var.cluster_config["label"]}-${local.role_postfix}_${var.cluster_id}"
  message_retention_seconds  = 600
  visibility_timeout_seconds = 360

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
  source_dir  = "${path.module}/lambda-functions"
  output_path = "${path.module}/lambda-functions.zip"
  type        = "zip"
}