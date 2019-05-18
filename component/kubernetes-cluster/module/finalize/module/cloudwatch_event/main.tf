resource "null_resource" "dependency_getter" {
  provisioner "local-exec" {
    command = "echo ${length(var.dependencies)}"
  }
}

resource "aws_cloudwatch_event_rule" "cluster_backup" {
  depends_on = ["null_resource.dependency_getter"]

  name                = "${var.cluster_config["label"]}-cluster-backup_${var.cluster_config["id"]}"
  schedule_expression = "cron(0 0 ? * * *)"
}

resource "aws_cloudwatch_event_target" "cluster_backup" {
  depends_on = ["null_resource.dependency_getter"]

  rule  = "${aws_cloudwatch_event_rule.cluster_backup.name}"
  arn   = "${var.backup_function["arn"]}"
}

resource "aws_lambda_permission" "cluster_backup" {
  depends_on = ["null_resource.dependency_getter"]

  function_name = "${var.backup_function["arn"]}"
  source_arn    = "${aws_cloudwatch_event_rule.cluster_backup.arn}"
  action        = "lambda:InvokeFunction"
  principal     = "events.amazonaws.com"
}

resource "aws_cloudwatch_event_rule" "renew_token" {
  depends_on = ["null_resource.dependency_getter"]

  name                = "${var.cluster_config["label"]}-renew-token_${var.cluster_config["id"]}"
  schedule_expression = "rate(12 hours)"
}

resource "aws_cloudwatch_event_target" "renew_token" {
  depends_on = ["null_resource.dependency_getter"]

  rule  = "${aws_cloudwatch_event_rule.renew_token.name}"
  arn   = "${var.renew_function["arn"]}"
}

resource "aws_lambda_permission" "renew_token" {
  depends_on = ["null_resource.dependency_getter"]

  function_name = "${var.renew_function["arn"]}"
  source_arn    = "${aws_cloudwatch_event_rule.renew_token.arn}"
  action        = "lambda:InvokeFunction"
  principal     = "events.amazonaws.com"
}