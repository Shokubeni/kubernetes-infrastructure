data "aws_iam_policy_document" "autoscaler_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(var.openid_provider.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:cluster-autoscaler"]
    }

    principals {
      identifiers = [var.openid_provider.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "autoscaler" {
  name               = "${var.cluster_data.name}Autoscaler_${var.cluster_data.id}"
  assume_role_policy = data.aws_iam_policy_document.autoscaler_assume_role.json
  description        = "Provides appropriate rights for cluster autoscaler"
}

resource "aws_iam_role_policy" "velero_backup_policy" {
  policy = file("${path.module}/policy/scale.json")
  role   = aws_iam_role.autoscaler.id
  name   = "ClusterAutoscalerPolicy"
}

resource "helm_release" "autoscaler" {
  chart     = "${var.root_dir}/component/kubernetes-cluster/module/deploy/module/aws-autoscaler/chart"
  namespace = "kube-system"
  name      = "aws-autoscaler"

  set {
    name  = "clusterLabel"
    value = var.cluster_data.label
  }

  set {
    name  = "clusterId"
    value = var.cluster_data.id
  }

  set {
    name  = "roleArn"
    value = aws_iam_role.autoscaler.arn
  }

  set {
    name  = "region"
    value = var.cluster_data.region
  }

  depends_on = [
    aws_iam_role.autoscaler,
    var.control_plane
  ]
}
