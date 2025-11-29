# Application Load Balancer
resource "aws_lb" "alb" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public.id, aws_subnet.public_b.id]   # attach to your public subnet(s)
  tags = {
    Project = var.project_name
  }
}

# Target Group for LB Controller NodePort
resource "aws_lb_target_group" "lb_tg" {
  name     = "${var.project_name}-lb-tg"
  port     = 30080                # fixed NodePort for HTTP
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  target_type = "instance" 
  health_check {
    path     = "/healthz"
    protocol = "HTTP"
    matcher  = "200-399"
  }

  tags = {
    Project = var.project_name
  }
}

# Listener for HTTP
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_tg.arn
  }
}

# Attach worker nodes to Target Group
resource "aws_lb_target_group_attachment" "workers" {
  count            = var.worker_count
  target_group_arn = aws_lb_target_group.lb_tg.arn
  target_id        = aws_instance.worker[count.index].id # IDs of worker nodes
  port             = 30080
}

# Security Group for ALB
resource "aws_security_group" "alb_sg" {
  name        = "${var.project_name}-alb-sg"
  description = "Allow HTTP access to ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project = var.project_name
  }
}

