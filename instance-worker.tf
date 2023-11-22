resource "aws_launch_template" "template-worker" {
  name_prefix = "locust-worker-template-"

  image_id = var.aws_ami

  instance_type = var.workers_instance_type

  key_name = var.key_name

  user_data = data.template_cloudinit_config.worker.rendered

  network_interfaces {
    associate_public_ip_address = true
    subnet_id                   = aws_subnet.public_subnet.id
    security_groups             = [aws_security_group.master_sg.id]
    delete_on_termination       = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "locust-worker"
    }
  }
}

resource "aws_autoscaling_group" "locust-workers-asg" {
  min_size         = var.workers_count
  max_size         = var.workers_count
  desired_capacity = var.workers_count

  launch_template {
    id      = aws_launch_template.template-worker.id
    version = "$Latest"
  }

  vpc_zone_identifier = [aws_subnet.public_subnet.id]

  health_check_type         = "ELB"
  health_check_grace_period = 300
  termination_policies      = ["OldestInstance"]
  lifecycle {
    create_before_destroy = true
  }
}
