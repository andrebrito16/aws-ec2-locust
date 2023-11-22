# resource "aws_launch_template" "locust-master-template" {
#   name_prefix   = "locust-master-template-"
#   image_id      = var.aws_ami
#   instance_type = var.master_instance_type
#   key_name      = var.key_name

#   user_data = data.template_cloudinit_config.master.rendered
#   iam_instance_profile {
#     name = aws_iam_instance_profile.ec2_instance_profile.name
#   }

#   network_interfaces {
#     associate_public_ip_address = true
#     subnet_id                   = aws_subnet.public_subnet.id
#     security_groups             = [aws_security_group.master_sg.id]
#     delete_on_termination       = true
#   }

#   tag_specifications {
#     resource_type = "instance"
#     tags = {
#       Name = "locust-master"
#     }
#   }
# }

# resource "aws_autoscaling_group" "locust-master-asg" {
#   name             = "locust-master-asg"
#   max_size         = 1
#   min_size         = 1
#   desired_capacity = 0

#   launch_template {
#     id      = aws_launch_template.locust-master-template.id
#     version = "$Latest"
#   }
#   vpc_zone_identifier = [aws_subnet.public_subnet.id]
#   target_group_arns   = [aws_lb_target_group.locust-master-tg.arn]

#   health_check_type         = "ELB"
#   health_check_grace_period = 300
#   termination_policies      = ["OldestInstance"]
#   lifecycle {
#     create_before_destroy = true
#   }
# }

resource "aws_instance" "locust-master-instance" {

  ami           = var.aws_ami
  instance_type = var.master_instance_type
  key_name      = var.key_name

  user_data       = data.template_cloudinit_config.master.rendered
  security_groups = [aws_security_group.master_sg.id]

  associate_public_ip_address = true

  subnet_id = aws_subnet.public_subnet.id


  tags = {
    Name = "locust-master"
  }
}

resource "aws_lb_target_group_attachment" "locust-master-tg-attachment" {
  target_group_arn = aws_lb_target_group.locust-master-tg.arn
  target_id        = aws_instance.locust-master-instance.id
  port             = 8089
}

data "aws_instances" "locust-master-instance" {

  depends_on = [aws_instance.locust-master-instance]

  filter {
    name   = "tag:Name"
    values = ["locust-master"]
  }
}

output "master_private_ip" {
  value = data.aws_instances.locust-master-instance.private_ips[0]
}
