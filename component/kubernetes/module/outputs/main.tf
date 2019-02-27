resource "null_resource" "dependency_getter" {
  provisioner "local-exec" {
    command = "echo ${length(var.dependencies)}"
  }
}

data "aws_s3_bucket_object" "kubernetes_config" {
  depends_on = [
    "null_resource.dependency_getter"
  ]

  bucket = "${var.secure_bucket_name}"
  key    = "configs/kubernetes.conf"
}

resource "local_file" "kubernetes_config" {
  depends_on = [
    "null_resource.dependency_getter"
  ]

  content  = "${data.aws_s3_bucket_object.kubernetes_config.body}"
  filename = "${var.root_dir}/output/kubernetes.conf"
}

resource "null_resource" "dependency_setter" {
  depends_on = [
    "local_file.kubernetes_config"
  ]
}