data "aws_iam_policy_document" "cert_manager_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(var.openid_provider.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${var.chart_namespace}:cert-manager"]
    }

    principals {
      identifiers = [var.openid_provider.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "cert_manager" {
  name               = "${var.cluster_data.name}CertManager_${var.cluster_data.id}"
  assume_role_policy = data.aws_iam_policy_document.cert_manager_assume_role.json
  description        = "Provides appropriate rights for CertManager deployment"
}

data "template_file" "cert_manager" {
  template = file("${path.module}/chart/policy/route53.json")

  vars = {
    hosted_zone = var.network_config.domain_info.public_zone
  }
}

resource "aws_iam_role_policy" "cert_manager_policy" {
  policy = data.template_file.cert_manager.rendered
  role   = aws_iam_role.cert_manager.id
  name   = "CertManagerPolicy"
}

resource "helm_release" "cert_manager" {
  chart     = "${var.root_dir}/component/basic-deployments/module/basic-deployments/module/cert-manager/chart"
  namespace = var.chart_namespace
  name      = "cert-manager"

  set {
    name  = "clusterRegion"
    value = var.cluster_data.region
  }

  set {
    name  = "publicZone"
    value = var.network_config.domain_info.public_zone
  }

  set {
    name  = "domainName"
    value = var.network_config.domain_info.domain_name
  }

  set {
    name  = "roleArn"
    value = aws_iam_role.cert_manager.arn
  }

  depends_on = [
    aws_iam_role_policy.cert_manager_policy,
    var.chart_namespace
  ]
}