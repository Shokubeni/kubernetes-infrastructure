data "template_file" "master" {
  template = file("${path.module}/master-policy.json")

  vars = {
    hosted_zone    = var.network_config.domain_info.public_zone
    cluster_bucket = var.cluster_bucket
    backup_bucket  = var.backup_bucket
  }
}

resource "aws_iam_role" "master" {
  name               = "${var.cluster_config.name}MasterNode_${var.cluster_config.id}"
  description        = "Enables resource access for cluster master node"
  assume_role_policy = file("${path.module}/assume-policy.json")
}

resource "aws_iam_role_policy" "master" {
  name   = "MasterNodeInlinePolicy"
  role   = aws_iam_role.master.id
  policy = data.template_file.master.rendered
}

resource "aws_iam_role_policy_attachment" "master" {
  role       = aws_iam_role.master.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

data "template_file" "worker" {
  template = file("${path.module}/worker-policy.json")

  vars = {
    cluster_bucket = var.cluster_bucket
  }
}

resource "aws_iam_role" "worker" {
  name               = "${var.cluster_config.name}WorkerNode_${var.cluster_config.id}"
  description        = "Enables resource access for cluster worker node"
  assume_role_policy = file("${path.module}/assume-policy.json")
}

resource "aws_iam_role_policy" "worker" {
  name   = "WorkerNodeInlinePolicy"
  role   = aws_iam_role.worker.id
  policy = data.template_file.worker.rendered
}

resource "aws_iam_role_policy_attachment" "worker" {
  role       = aws_iam_role.worker.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}
