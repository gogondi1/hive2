# Create first private route table and associate it with private subnet
 
resource "aws_route_table" "hive_prv_rtb01" {
    vpc_id = aws_vpc.hive_vpc01.id
    route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.hive-nat-gateway-1.id
  }
    tags =  {
        Name      = "Hive private RTB01"
        Terraform = "True"
  }
depends_on = [aws_nat_gateway.hive-nat-gateway-1]
}
 
resource "aws_route_table_association" "hive_rtbass01" {
    subnet_id = aws_subnet.hive-prvsub01.id
    route_table_id = aws_route_table.hive_prv_rtb01.id
  depends_on = [aws_route_table.hive_prv_rtb01]
}
 
# Create second private route table and associate it with private subnet in eu-west-1b 
 
resource "aws_route_table" "hive_prv_rtb02" {
    vpc_id = aws_vpc.hive_vpc01.id
    route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.hive-nat-gateway-2.id
  }
    tags =  {
        Name      = "Hive private RTB02"
        Terraform = "True"
  }
depends_on = [aws_nat_gateway.hive-nat-gateway-2]
}
 
resource "aws_route_table_association" "hive_rtbass02" {
    subnet_id = aws_subnet.hive-prvsub02.id
    route_table_id = aws_route_table.hive_prv_rtb02.id
   depends_on = [aws_route_table.hive_prv_rtb02]
}
