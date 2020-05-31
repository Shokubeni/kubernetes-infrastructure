data "aws_partition" "current" {}

data "aws_iam_policy_document" "control_plane_role_assume" {
  statement {
    sid = "EKSClusterAssumeRole"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["eks.${data.aws_partition.current.dns_suffix}"]
    }
  }
}

resource "aws_iam_role" "control_plane" {
  name               = "${var.cluster_data.name}ControlPlane_${var.cluster_data.id}"
  assume_role_policy = data.aws_iam_policy_document.control_plane_role_assume.json
  description        = "Provides appropriate rights for the cluster controle plane"
}

resource "aws_iam_role_policy_attachment" "control_plane_cluster_policy" {
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.control_plane.name
}

resource "aws_iam_role_policy_attachment" "control_plane_service_policy" {
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.control_plane.name
}

data "aws_iam_policy_document" "worker_node_assume_role" {
  statement {
    sid = "EKSWorkerAssumeRole"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.${data.aws_partition.current.dns_suffix}"]
    }
  }
}

resource "aws_iam_role" "worker_node" {
  name               = "${var.cluster_data.name}WorkerNode_${var.cluster_data.id}"
  assume_role_policy = data.aws_iam_policy_document.worker_node_assume_role.json
  description        = "Provides appropriate rights for the cluster worker nodes"
}

resource "aws_iam_role_policy_attachment" "worker_ecr_policy" {
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.worker_node.name
}

resource "aws_iam_role_policy_attachment" "worker_node_policy" {
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.worker_node.name
}

resource "aws_iam_role_policy_attachment" "worker_cni_policy" {
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.worker_node.name
}