resource "aws_security_group" "master" {
  name   = "${var.cluster_info["name"]} Master Node"
  vpc_id = "${var.vpc_id}"

  ingress {
    description = "SSH client"
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Kubernetes API server"
    protocol    = "tcp"
    from_port   = 6443
    to_port     = 6443
    cidr_blocks = ["0.0.0.0/0"]
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
      "kubernetes.io/cluster/${var.cluster_info["label"]}", "owned",
      "Environment", "${terraform.workspace}"
    )
  )}"
}

resource "aws_security_group" "worker" {
  name   = "${var.cluster_info["name"]} Worker Node"
  vpc_id = "${var.vpc_id}"

  ingress {
    description = "SSH client"
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

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
    description     = "Kubelet API"
    protocol        = "tcp"
    from_port       = 10250
    to_port         = 10250
    self            = "true"
    security_groups = ["${aws_security_group.master.id}"]
  }

  ingress {
    description = "NodePort Services"
    protocol    = "tcp"
    from_port   = 30000
    to_port     = 32767
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "NodePort Services"
    protocol    = "udp"
    from_port   = 30000
    to_port     = 32767
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(
    map(
      "kubernetes.io/cluster/${var.cluster_info["label"]}", "owned",
      "Environment", "${terraform.workspace}"
    )
  )}"
}