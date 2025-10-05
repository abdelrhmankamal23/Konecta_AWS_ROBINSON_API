resource "aws_lb" "robinson_api_lb" {
  name               = "Robin-servi-1FS7261GOYADF"
  load_balancer_type = "application"
  subnets            = ["subnet-03648efa6a2335d6c", "subnet-0ac3164a7d6c5fd05"]
  security_groups    = ["sg-094a936b7e8451604"]
}

resource "aws_lb_target_group" "robinson_api_tg" {
  name        = "Robins-servi-KSHCOYQ0W5NS"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "vpc-07d4f0656a0760b05"
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 60
    matcher             = "200"
    path                = "/robinson-api/prd/v2/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 5
  }
}

resource "aws_lb" "robinson_api_private_lb" {
  name               = "balanceador-servi-balan-private"
  load_balancer_type = "application"
  internal           = true
  subnets            = ["subnet-0156021c19e67844d", "subnet-0c391907aa30b3c96"]
  security_groups    = ["sg-094a936b7e8451604"]
}

resource "aws_lb_target_group" "robinson_api_private_tg" {
  name        = "robinson-ecs-prv"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "vpc-07d4f0656a0760b05"
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 60
    matcher             = "200"
    path                = "/robinson-api/prd/v2"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 10
    unhealthy_threshold = 5
  }
}