# Create Security Group for ASG

resource "aws_security_group" "hive_asg_sg" {
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
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/16"
    ]
  }
  ingress {
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/16"
    ]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [
      aws_security_group.hive_bastion_sg.id
    ]
  }
  tags = {
    Name        = "HIVE ASG Security Group"
    Terraform   = "true"
  } 
}

# Create Launch Configuration
data "aws_ami" "ubuntu" {

  owners = ["099720109477"]


  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20210223"]
  }

  filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

}





resource "aws_launch_configuration" "hive_launch_config" {
  name_prefix   = "Hive Launch Configuration"
  image_id      = data.aws_ami.ubuntu.image_id
  instance_type = "t2.micro"
  security_groups = [aws_security_group.hive_asg_sg.id]
  key_name = aws_key_pair.ssh-key.key_name
  user_data=<<-EOF
               #!/bin/bash
               sudo apt update -y
               sudo apt install git -y 
               curl -fsSL https://get.docker.com -o get-docker.sh
               sudo sh get-docker.sh
               sudo usermod -aG docker ubuntu
               mkdir /home/ubuntu/hive
               cd /hive 
               git clone https://github.com/hivehr/devops-assessment.git
               cd devops-assessment/
               sudo docker build -t nodeapp1:1.0 .
               sudo docker container run -itd -p 3000:3000 --name=hiveapp nodeapp1:1.0
            EOF
  associate_public_ip_address = false
  lifecycle {
    create_before_destroy = true
  }
}

# Create Create  ASG

resource "aws_autoscaling_group" "hive_asg01" {
  name                 = "Hive Nodejsapp ASG"
  launch_configuration = aws_launch_configuration.hive_launch_config.name
  health_check_type    = "ELB"
  min_size             = 1
  max_size             = 3
  desired_capacity     = 1

  vpc_zone_identifier = [
    aws_subnet.hive-prvsub01.id,
    aws_subnet.hive-prvsub02.id
  ]
  target_group_arns = [aws_lb_target_group.target01.arn]
  lifecycle {
    create_before_destroy = true
  }
  tag {
    key                 = "Name"
    value               = "Hive ASG"
    propagate_at_launch = true  
  }
}

resource "aws_autoscaling_policy" "cpu" {
  name                   = "nodeapp-cpu-test"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.hive_asg01.name
}

resource "aws_cloudwatch_metric_alarm" "nodeapp_cpu" {
  alarm_name          = "nodeapp_cpu_utlization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.hive_asg01.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.cpu.arn]
}
