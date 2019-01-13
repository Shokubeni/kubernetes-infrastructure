resource "aws_iam_role" "lambda" {
  name               = "${var.cluster_config["name"]}LifecycleLambda_${var.cluster_id}"
  description        = "Enables lambda functions to handle ASG instance lifecycle hooks"
  assume_role_policy = "${file("${path.module}/assume-policy.json")}"
}

resource "aws_iam_role_policy" "lambda" {
  name   = "LifecycleLambdaInlinePolicy"
  role   = "${aws_iam_role.lambda.id}"
  policy = "${file("${path.module}/lambda-policy.json")}"
}