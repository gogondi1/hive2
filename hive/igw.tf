# Create and Attach internet gateway

resource "aws_internet_gateway" "hive-igw" {
  vpc_id = aws_vpc.hive_vpc01.id
  tags = {
    Name        = "Hive Internet Gateway"
    Terraform   = "true"
  }
depends_on  = [aws_vpc.hive_vpc01]
}
