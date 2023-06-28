resource "aws_instance" "bhavya-test" {
  ami           = "ami-05e411cf591b5c9f6"  
  instance_type = "t2.micro"      

  tags = {
    Name = "web-server"
  }

  user_data = <<-EOF
    #!/bin/bash
    echo '<html>
    <head>
    <title>Hello World</title>
    </head>
    <body>
    <h1>Hello World!</h1>
    </body>
    </html>' > /var/www/html/index.html
    EOF
}

resource "aws_acm_certificate" "example" {
  domain_name       = var.acm_domain      # Update with your domain name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_zone" "bhavya-route53" {
  name = var.aws-route53-name  # Update with your domain name

  tags = {
    Environment = "Dev"
  }
}

resource "aws_route53_record" "bhavya-record" {
  zone_id = aws_route53_zone.bhavya-route53.zone_id
  name    = "alpha"
  type    = "A"
  ttl     = 300

  records = [
    aws_instance.bhavya-test.private_ip,
  ]
}

resource "aws_lb" "bhavya-lb" {
  name               = "bhavya-lb"
  internal           = false
  load_balancer_type = "application"

  subnets = var.subnets 

  security_groups = [aws_security_group.lb_sg.id]
}

resource "aws_lb_listener" "bhavya-listener" {
  load_balancer_arn = aws_lb.bhavya-lb.arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = var.acm-cert
    default_action {
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Default response"
      status_code  = "200"
    }
  }
}

resource "aws_security_group" "lb_sg" {
  name        = "bhavya-lb-sg"
  description = "Security group for the load balancer"
  vpc_id      = var.vpc-id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "bhavya-target-lb" {
  name        = "bhavya-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"

  health_check {
    path = "/health"
  }

  vpc_id = var.vpc-id
}

resource "aws_lb_listener_rule" "bhavya-listner-rule" {
  listener_arn = aws_lb_listener.bhavya-listener.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bhavya-target-lb.arn
  }

  condition {
    host_header {
      values = ["bhavya-test.com"] 
    }
  }
}
