resource "aws_security_group" "master" {
  name   = "${var.cluster_config["label"]}-master_${var.cluster_id}"
  vpc_id = "${var.virtual_cloud_id}"

  ingress {
    description = "SSH client"
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    self        = "true"
  }

  ingress {
    description = "Kubernetes API server"
    protocol    = "tcp"
    from_port   = 6443
    to_port     = 6443
    self        = "true"
  }

  ingress {
    description = "Etcd server client API"
    protocol    = "tcp"
    from_port   = 2379
    to_port     = 2380
    self        = "true"
  }

  ingress {
    description = "Kubelet API and schedueler"
    protocol    = "tcp"
    from_port   = 10250
    to_port     = 10252
    self        = "true"
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(
    map(
      "Name", "${var.cluster_config["name"]} Master Node",
      "kubernetes.io/cluster/${var.cluster_id}", "owned"
    )
  )}"
}

resource "aws_security_group" "worker" {
  name   = "${var.cluster_config["label"]}-worker_${var.cluster_id}"
  vpc_id = "${var.virtual_cloud_id}"

  ingress {
    description     = "Kubelet API"
    protocol        = "tcp"
    from_port       = 10250
    to_port         = 10250
    self            = "true"
    security_groups = ["${aws_security_group.master.id}"]
  }

  ingress {
    description     = "NodePort Services"
    protocol        = "tcp"
    from_port       = 30000
    to_port         = 32767
    self            = "true"
    security_groups = ["${aws_security_group.master.id}"]
  }

  egress {
    protocol        = "-1"
    from_port       = 0
    to_port         = 0
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = "${merge(
    map(
      "Name", "${var.cluster_config["name"]} Worker Node",
      "kubernetes.io/cluster/${var.cluster_id}", "owned"
    )
  )}"
}

resource "aws_security_group" "balancer" {
  name   = "${var.cluster_config["label"]}-balancer_${var.cluster_id}"
  vpc_id = "${var.virtual_cloud_id}"

  ingress {
    description = "HTTP traffic"
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS traffic"
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Kubernetes API server"
    protocol    = "tcp"
    from_port   = 6443
    to_port     = 6443
    security_groups = [
      "${aws_security_group.master.id}",
      "${aws_security_group.worker.id}"
    ]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(
    map(
      "Name", "${var.cluster_config["name"]} Load Balancer",
      "kubernetes.io/cluster/${var.cluster_id}", "owned"
    )
  )}"
}

resource "aws_security_group_rule" "master_http_from_balancer" {
  description              = "HTTP traffic"
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.balancer.id}"
  security_group_id        = "${aws_security_group.master.id}"
}

resource "aws_security_group_rule" "master_https_from_balancer" {
  description              = "HTTPS traffic"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.balancer.id}"
  security_group_id        = "${aws_security_group.master.id}"
}

resource "aws_security_group_rule" "master_api_from_balancer" {
  description              = "Kubernetes API server"
  type                     = "ingress"
  from_port                = 6443
  to_port                  = 6443
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.balancer.id}"
  security_group_id        = "${aws_security_group.master.id}"
}

resource "aws_security_group_rule" "master_api_from_worker" {
  description              = "Kubernetes API server"
  type                     = "ingress"
  from_port                = 6443
  to_port                  = 6443
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.worker.id}"
  security_group_id        = "${aws_security_group.master.id}"
}