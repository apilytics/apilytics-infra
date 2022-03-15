resource "aws_lb" "this" {
  name               = "${var.name}-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.this.id]
  subnets            = values(aws_subnet.public)[*].id
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.this.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  depends_on = [aws_acm_certificate_validation.this]
}

resource "aws_lb_target_group" "this" {
  name = var.name

  # Must be specified: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#port
  # even though irrelevant and not used: https://stackoverflow.com/a/42823808/9835872
  port = 80

  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.this.id
  depends_on  = [aws_lb.this]

  health_check {
    interval = 60
    path     = "/healthz"
    matcher  = "200"
  }
}
