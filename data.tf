data "template_cloudinit_config" "master" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "master.sh"
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/app/master.sh", {
    })
  }
}

data "template_cloudinit_config" "worker" {
  gzip          = true
  base64_encode = true

  depends_on = [aws_instance.locust-master-instance]

  part {
    filename     = "worker.sh"
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/app/worker.sh", {
      MASTER_IP = data.aws_instances.locust-master-instance.private_ips[0]
    })
  }
}
