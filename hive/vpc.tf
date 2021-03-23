# Define VPC Variable

variable "aws-vpc-cidr" {
  type= string
  default="10.10.0.0/16"
}

# Create VPC

resource "aws_vpc" "hive_vpc01" {
  cidr_block = var.aws-vpc-cidr
  instance_tenancy = "default"
  tags = {
    Name = "Hive_VPC_01"
    Terrafrom = "True"
  }
}
