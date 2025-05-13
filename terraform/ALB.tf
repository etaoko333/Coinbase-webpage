resource "aws_lb" "app_lb" {
  name               = "react-app-alb"
  load_balancer_type = "application"
  subnets            = aws_subnet.public_subnet_az1.id
  security_groups    = [aws_security_group.react.sg.id]
}

resource "aws_lb_target_group" "app_tg" {
  name     = "react-app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  target_type = "ip"
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
