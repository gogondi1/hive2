# CREATE ELASTIC IP ADDRESS FOR NAT GATEWAY

  resource "aws_eip" "hive-nat1" {
}
  resource "aws_eip" "hive-nat2" {
}
  

# CREATE NAT GATEWAY in public subnet01

  resource "aws_nat_gateway" "hive-nat-gateway-1" {
  allocation_id = aws_eip.hive-nat1.id
  subnet_id     = aws_subnet.hive-pubsub01.id

  tags = {
    Name        = "Nat Gateway-1a"
    Terraform   = "True"

}
  depends_on  = [aws_subnet.hive-pubsub01]
  
}

# CREATE NAT GATEWAY in Public subnet02

resource "aws_nat_gateway" "hive-nat-gateway-2" {
  allocation_id = aws_eip.hive-nat2.id
  subnet_id     = aws_subnet.hive-pubsub02.id

  tags = {
    Name        = "Nat Gateway-1b"
    Terraform   = "True"
  }
depends_on  = [aws_subnet.hive-pubsub02]
}
