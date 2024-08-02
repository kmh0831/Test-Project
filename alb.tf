# ALB 생성
resource "aws_lb" "alb" {
  name               = "Terraform-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_http.id]
  subnets            = [aws_subnet.public-sub-1.id, aws_subnet.public-sub-2.id]

  tags = {
    Name = "ALB"
  }
}

# ALB Target Groups
resource "aws_lb_target_group" "alb_tg" {
  name        = "ALB-TG"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc-1.id
  target_type = "instance"

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    timeout             = 5
  }

  tags = {
    Name = "alb-tg"
  }
}

# ALB listener
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}