# Create Networking Load Balancer Security Group

resource "aws_security_group" "nlb_sg" {
  vpc_id = aws_vpc.hive_vpc01.id
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  tags = {
    Name        = "Hive NLB Security Group"
    Terraform   = "True"   
  } 
}

# Create Network Load Balancer
resource "aws_lb" "load_balancer" {
  name                              = "test-nlb01" 
  internal                          = false
  load_balancer_type                = "network"
  subnets = [
    aws_subnet.hive-pubsub01.id,
    aws_subnet.hive-pubsub02.id
  ]
  tags = {
    Name        = "NLB-01"
    Terraform   = "True"
  }
}

resource "aws_lb_target_group" "target01" {
    name                  = "hive-nodeapp01"
    port                  = 3000
    protocol              = "TCP"
  vpc_id                  = aws_vpc.hive_vpc01.id
  target_type             = "instance"
  deregistration_delay    = 90
health_check {
    interval            = 30
    port                = 3000
    protocol            = "TCP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
  tags = {
    Name        = "Nodeapp_target"
    Terraform   = "True"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn       = aws_lb.load_balancer.arn
      port                = "80"
      protocol            = "TCP"
      default_action {
        target_group_arn = aws_lb_target_group.target01.arn
        type             = "forward"
      }

}
