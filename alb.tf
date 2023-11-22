resource "aws_lb" "locust_lb" {
  name                       = "locust-lb"
  internal                   = false
  load_balancer_type         = "application"
  enable_deletion_protection = false

  subnets = [aws_subnet.public_subnet.id, aws_subnet.public_subnet_bckp.id]

  security_groups = [aws_security_group.master_sg.id]

  tags = {
    Name = "locust-lb"
  }
}

output "lb_host" {
  value = aws_lb.locust_lb.dns_name
}

resource "aws_lb_listener" "locust-master-listener" {
  load_balancer_arn = aws_lb.locust_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.locust-master-tg.arn
  }
}

resource "aws_lb_target_group" "locust-master-tg" {
  name        = "locust-master-tg"
  port        = 8089
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "instance"


}