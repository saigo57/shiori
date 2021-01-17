resource "aws_alb" "alb" {
  name                       = "shiori-${terraform.workspace}-alb"
  security_groups            = [aws_security_group.web_sg.id]
  subnets                    = [aws_subnet.public_1.id, aws_subnet.public_2.id]
  internal                   = false
  enable_deletion_protection = false
}

resource "aws_alb_target_group" "alb_tg" {
  name     = "shiori-${terraform.workspace}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    interval            = 30
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
    matcher             = 200
  }
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.alb_config["certificate_arn"]

  default_action {
    target_group_arn = aws_alb_target_group.alb_tg.arn
    type             = "forward"
  }
}

resource "aws_alb_listener" "alb" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# resource "aws_alb_target_group_attachment" "alb" {
#   target_group_arn = "${aws_alb_target_group.alb.arn}"
#   target_id        = "${aws_spot_instance_request.web.spot_instance_id}"コンテナにつなぐ
#   port             = 80
# }
