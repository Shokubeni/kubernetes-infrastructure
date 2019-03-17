data "archive_file" "lambda_zip" {
  source_dir  = "${path.module}/functions"
  output_path = "${path.module}/functions.zip"
  type        = "zip"
}

resource "aws_lambda_function" "cluster_backup" {
  function_name                  = "${var.cluster_config["label"]}-cluster-backup_${var.cluster_config["id"]}"
  source_code_hash               = "${data.archive_file.lambda_zip.output_base64sha256}"
  handler                        = "build/cluster-backup.handler"
  filename                       = "${path.module}/functions.zip"
  role                           = "${var.cloudwatch_role["arn"]}"
  runtime                        = "nodejs8.10"
  timeout                        = 600
  memory_size                    = 512
  reserved_concurrent_executions = 1

  environment {
    variables = {
      MASTER_AUTOSCALING_GROUP = "${var.cluster_config["label"]}-master_${var.cluster_config["id"]}"
      ETCD_BACKUP_COMMAND      = "${var.system_commands["cluster_etcd_backup"]}"
      S3_BUCKED_NAME           = "${var.secure_bucket["id"]}"
      CLUSTER_ID               = "${var.cluster_config["id"]}"
    }
  }
}

resource "aws_lambda_function" "master_lifecycle" {
  function_name                  = "${var.cluster_config["label"]}-master-lifecycle_${var.cluster_config["id"]}"
  source_code_hash               = "${data.archive_file.lambda_zip.output_base64sha256}"
  handler                        = "build/master-initialize.handler"
  filename                       = "${path.module}/functions.zip"
  role                           = "${var.master_role["arn"]}"
  runtime                        = "nodejs8.10"
  timeout                        = 600
  memory_size                    = 512
  reserved_concurrent_executions = 5

  environment {
    variables = {
      MASTER_AUTOSCALING_GROUP     = "${var.cluster_config["label"]}-master_${var.cluster_config["id"]}"
      NODE_RUNTIME_INSTALL_COMMAND = "${var.system_commands["node_runtime_install"]}"
      GENERAL_MASTER_INIT_COMMAND  = "${var.system_commands["general_master_init"]}"
      STACKED_MASTER_INIT_COMMAND  = "${var.system_commands["stacked_master_init"]}"
      COMMON_WORKER_INIT_COMMAND   = "${var.system_commands["common_worker_init"]}"
      KUBERNETES_VERSION           = "${var.cluster_config["kubernetes"]}"
      DOCKER_VERSION               = "${var.cluster_config["docker"]}"
      LOAD_BALANCER_DNS            = "${var.balancer_data["dns"]}"
      S3_BUCKED_NAME               = "${var.secure_bucket["id"]}"
      SQS_QUEUE_URL                = "${var.master_queue["id"]}"
      CLUSTER_ID                   = "${var.cluster_config["id"]}"
      TASK_EXECUTE_LIMIT           = 600
      TASK_REFRESH_TIMEOUT         = 30
    }
  }
}

resource "aws_lambda_function" "worker_lifecycle" {
  function_name                  = "${var.cluster_config["label"]}-worker-lifecycle_${var.cluster_config["id"]}"
  source_code_hash               = "${data.archive_file.lambda_zip.output_base64sha256}"
  handler                        = "build/worker-initialize.handler"
  filename                       = "${path.module}/functions.zip"
  role                           = "${var.worker_role["arn"]}"
  runtime                        = "nodejs8.10"
  timeout                        = 600
  memory_size                    = 512
  reserved_concurrent_executions = 5

  environment {
    variables = {
      MASTER_AUTOSCALING_GROUP     = "${var.cluster_config["label"]}-master_${var.cluster_config["id"]}"
      NODE_RUNTIME_INSTALL_COMMAND = "${var.system_commands["node_runtime_install"]}"
      COMMON_WORKER_INIT_COMMAND   = "${var.system_commands["common_worker_init"]}"
      KUBERNETES_VERSION           = "${var.cluster_config["kubernetes"]}"
      DOCKER_VERSION               = "${var.cluster_config["docker"]}"
      S3_BUCKED_NAME               = "${var.secure_bucket["id"]}"
      SQS_QUEUE_URL                = "${var.worker_queue["id"]}"
      CLUSTER_ID                   = "${var.cluster_config["id"]}"
      TASK_EXECUTE_LIMIT           = 600
      TASK_REFRESH_TIMEOUT         = 30
    }
  }
}