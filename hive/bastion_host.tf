# Create Bastion Host Security Group

resource "aws_security_group" "hive_bastion_sg" {
  vpc_id = aws_vpc.hive_vpc01.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  tags = {
    Name        = "Bastion Security Group"
    Terraform   = "true"
    } 
depends_on = [aws_vpc.hive_vpc01]
}

# Define Variables for  BASTION HOST 

variable "ami_id" {
  type= string

}

variable "instance_type" {
 type= string
}

# CREATE BASTION HOST IN PUBLIC SUBNET

resource "aws_instance" "hive_bastion_host" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = aws_key_pair.ssh-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.hive_bastion_sg.id]
  subnet_id = aws_subnet.hive-pubsub01.id
  tags = {
    Name = "hive Bastion Host"
    Terraform = true
  }
  depends_on = [aws_route_table_association.hive-pubass01]
}

# Output variable for Bastion Host

output "instance_ip_addr" {
  value = aws_instance.hive_bastion_host.public_ip
}

