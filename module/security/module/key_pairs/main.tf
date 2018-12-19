resource "null_resource" "master_keys_generation" {
  provisioner "local-exec" {
    command = "rm cluster/master_node_* || true && ssh-keygen -t rsa -b 4096 -f cluster/master_node_rsa -q -N \"\""
  }
}

resource "null_resource" "worker_keys_generation" {
  provisioner "local-exec" {
    command = "rm cluster/worker_node_* || true && ssh-keygen -t rsa -b 4096 -f cluster/worker_node_rsa -q -N \"\""
  }
}

resource "aws_key_pair" "master_node" {
  depends_on = ["null_resource.master_keys_generation"]
  key_name   = "${var.cluster_info["label"]}-master-node"
  public_key = "${file("cluster/master_node_rsa.pub")}"
}

resource "aws_key_pair" "worker_node" {
  depends_on = ["null_resource.worker_keys_generation"]
  key_name   = "${var.cluster_info["label"]}-worker-node"
  public_key = "${file("cluster/worker_node_rsa.pub")}"
}