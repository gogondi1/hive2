# Create a public route table for Public Subnets
 
resource "aws_route_table" "hive_pub_rtb01" {
  vpc_id = aws_vpc.hive_vpc01.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.hive-igw.id
  }
  tags = {
    Name        = "Hive Public Route Table"
    Terraform   = "true"
    }
depends_on = [aws_internet_gateway.hive-igw]
}
 
# Attach a public route table to Public Subnets
 
resource "aws_route_table_association" "hive-pubass01" {
  subnet_id = aws_subnet.hive-pubsub01.id
  route_table_id = aws_route_table.hive_pub_rtb01.id
depends_on = [aws_route_table.hive_pub_rtb01]
}
 
resource "aws_route_table_association" "hive-pubass02" {
  subnet_id = aws_subnet.hive-pubsub02.id
  route_table_id = aws_route_table.hive_pub_rtb01.id
 depends_on = [aws_route_table.hive_pub_rtb01]
 
}
