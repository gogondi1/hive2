#Define Subnet variables
variable "aws-pubsub01-cidr" {
  type= string
  default="10.10.1.0/24"
}
variable "aws-pubsub02-cidr" {
  type= string
  default="10.10.2.0/24"
}
variable "aws-prvsub01-cidr" {
  type= string
  default="10.10.3.0/24"
}
variable "aws-prvsub02-cidr" {
  type= string
  default="10.10.4.0/24"
}



variable "availability_zone1" {
    type= string
    
   }

variable "availability_zone2" {
    type= string
    
   }

variable "availability_zone3" {
    type= string
    
   }

variable "availability_zone4" {
    type= string
    
   }


# Create Public Subnets
resource "aws_subnet" "hive-pubsub01" {
  vpc_id = aws_vpc.hive_vpc01.id
  cidr_block = var.aws-pubsub01-cidr
  availability_zone = var.availability_zone1
  map_public_ip_on_launch = "true"
  tags = {
    Name        = "Hive public subnet01"
    Terraform   = "True"
  }
depends_on = [aws_vpc.hive_vpc01]
}

resource "aws_subnet" "hive-pubsub02" {
  vpc_id = aws_vpc.hive_vpc01.id
  cidr_block = var.aws-pubsub02-cidr
  availability_zone = var.availability_zone2
  map_public_ip_on_launch = "true"
  tags = {
    Name        = "Hive public subnet02"
    Terraform   = "True"
  }
depends_on = [aws_vpc.hive_vpc01]
}

# Create Private Subnets


resource "aws_subnet" "hive-prvsub01" {
  vpc_id = aws_vpc.hive_vpc01.id
  cidr_block = var.aws-prvsub01-cidr
  availability_zone = var.availability_zone3
  map_public_ip_on_launch = "false"
  tags = {
    Name        = "Hive Private Subnet01"
    Terraform   = "True"
  }
depends_on = [aws_vpc.hive_vpc01]
}

resource "aws_subnet" "hive-prvsub02" {
  vpc_id = aws_vpc.hive_vpc01.id
  cidr_block = var.aws-prvsub02-cidr
  availability_zone = var.availability_zone4
  map_public_ip_on_launch = "false"
  tags = {
    Name        = "Hive Private Subnet02"
    Terraform   = "True"
  }
depends_on = [aws_vpc.hive_vpc01]
}


