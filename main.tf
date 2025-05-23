# Creates var.instance_count EC2 instances on different subnets 
module "web_instance" {
  source                 = "./modules/ec2-instance"
  instance_type          = "t2.micro"
  ami                    = "ami-0f415cc2783de6675"
  vpc_security_group_ids = [aws_security_group.demo_sg.id]
  instance_count         = 2
  subnet_ids             = data.aws_subnets.default_vpc_subnets.ids
  openai_api_key         = var.openai_api_key
}

# Get all subnets in the default VPC
data "aws_subnets" "default_vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [aws_default_vpc.default.id]
  }
}

data "aws_subnet" "subnet_details" {
  count = length(data.aws_subnets.default_vpc_subnets.ids)
  id    = data.aws_subnets.default_vpc_subnets.ids[count.index]
}

resource "aws_security_group" "alb" {
  name   = "alb-sg"
  vpc_id = aws_default_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "app" {
  name               = "my-app-lb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.alb.id]
  subnets	     = data.aws_subnets.default_vpc_subnets.ids
}


resource "aws_lb_target_group" "app" {
  name     = "my-app-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_default_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port		= 8080
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

resource "aws_lb_target_group_attachment" "app" {
  count            = length(module.web_instance.instance_ids) 
  target_group_arn = aws_lb_target_group.app.arn
  target_id        = module.web_instance.instance_ids[count.index]
  port             = 8080
}


resource "aws_default_vpc" "default" {
}

resource "aws_security_group" "demo_sg" {
  name   = "demo-sg"
  vpc_id = aws_default_vpc.default.id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [for s in data.aws_subnet.subnet_details : s.cidr_block]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [for s in data.aws_subnet.subnet_details : s.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

