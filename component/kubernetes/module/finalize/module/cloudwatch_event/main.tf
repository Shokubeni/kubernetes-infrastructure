resource "null_resource" "dependency_getter" {
  provisioner "local-exec" {
    command = "echo ${length(var.dependencies)}"
  }
}

resource "aws_cloudwatch_event_rule" "cluster_backup" {
  depends_on = ["null_resource.dependency_getter"]

  name                = "${var.cluster_config["label"]}-cluster-backup_${var.cluster_config["id"]}"
  schedule_expression = "rate(2 minutes)"
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