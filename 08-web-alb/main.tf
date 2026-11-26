## creating application load balancer ##
resource "aws_lb" "web_alb" {
  name               = "${var.project_name}-${var.environment}-${var.common_tags.Component}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_ssm_parameter.web_alb_sg_id.value]
  subnets            = split(",", data.aws_ssm_parameter.public_subnet_ids.value)

  enable_deletion_protection = false


  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.environment}-web-alb"
    }
  )
}

## creating listener ##
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = "80"
  protocol          = "HTTP"
  

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>This is fixed response from WEB ALB</h1>"
      status_code  = "200"
    }
  }
}

## creating listener ##
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_ssm_parameter.acm_certificate_arn.value

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>This is fixed response from WEB ALB HTTPS</h1>"
      status_code  = "200"
    }
  }
}

## creating r53 record for web_alb ##
module "records" {
  source = "terraform-aws-modules/route53/aws"

  name = var.zone_name
  create_zone = false

  records = {
    app-alb = {
      name    = "web-${var.environment}"
      type    = "A"
      allow_overwrite = true
      alias = {
        name    = aws_lb.web_alb.dns_name
        zone_id = aws_lb.web_alb.zone_id
      }
    }
  }
}