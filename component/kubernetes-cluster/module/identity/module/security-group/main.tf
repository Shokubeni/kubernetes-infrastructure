resource "aws_security_group" "control_plane" {
  name        = "${var.cluster_data.label}-control-plane_${var.cluster_data.id}"
  description = "Control plane security group"
  vpc_id      = var.virtual_cloud_id

  lifecycle {
    ignore_changes = all
  }

  tags = {
    "Name" = "${var.cluster_data.name} Control Plane",
    "kubernetes.io/cluster/${var.cluster_data.label}_${var.cluster_data.id}" = "owned"
  }
}

resource "aws_security_group_rule" "control_plane_api_ingress" {
  description              = "Allow worker to communicate with control plane API server"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.worker_node.id
  security_group_id        = aws_security_group.control_plane.id
}

resource "aws_security_group_rule" "control_plane_workers_egress" {
  description              = "Allow control plane to communicate with worker workloads"
  type                     = "egress"
  from_port                = 10250
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.worker_node.id
  security_group_id        = aws_security_group.control_plane.id
}

resource "aws_security_group" "worker_node" {
  name        = "${var.cluster_data.label}-worker-node_${var.cluster_data.id}"
  description = "Worker nodes security group"
  vpc_id      = var.virtual_cloud_id

  lifecycle {
    ignore_changes = all
  }

  tags = {
    "Name" = "${var.cluster_data.name} Worker Node"
    "kubernetes.io/cluster/${var.cluster_data.label}_${var.cluster_data.id}" = "owned"
  }
}

resource "aws_security_group_rule" "worker_node_workloads_ingress" {
  description              = "Allow worker workloads to receive control plane communication"
  type                     = "ingress"
  from_port                = 10250
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.control_plane.id
  security_group_id        = aws_security_group.worker_node.id
}

resource "aws_security_group_rule" "worker_node_api_ingress" {
  description              = "Allow worker API server to receive control plane communication"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.control_plane.id
  security_group_id        = aws_security_group.worker_node.id
}

resource "aws_security_group_rule" "worker_node_siblings_ingress" {
  description              = "Allow worker workloads to communicate with other worker nodes"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  source_security_group_id = aws_security_group.worker_node.id
  security_group_id        = aws_security_group.worker_node.id
}

resource "aws_security_group_rule" "worker_nodes_unlimited_egress" {
  description       = "Allow worker node to communicate with all possible services"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.worker_node.id
}

resource "aws_security_group" "nat_instance" {
  name        = "${var.cluster_data.label}-nat-instance_${var.cluster_data.id}"
  description = "NAT instances security group"
  vpc_id      = var.virtual_cloud_id

  ingress {
    description = "Allow control plane and workers to communicate with nat instance"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    security_groups = [
      aws_security_group.control_plane.id,
      aws_security_group.worker_node.id
    ]
  }

  egress {
    description = "Allow nat instances to communicate with all possible services"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    ignore_changes = all
  }

  tags = {
    "Name" = "${var.cluster_data.name} NAT Instance"
    "kubernetes.io/cluster/${var.cluster_data.label}_${var.cluster_data.id}" = "owned"
  }
}