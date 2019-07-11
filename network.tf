resource "aws_vpc" "example" {
  cidr_block ="10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "example"
  }
}

# subnet public
resource "aws_subnet" "public_ap_northeast_a" {
  vpc_id = aws_vpc.example.id
  cidr_block = "10.0.2.0/24"

  map_public_ip_on_launch = true
  availability_zone = "ap-northeast-1a"
}

resource "aws_subnet" "public_ap_northeast_c" {
  vpc_id = aws_vpc.example.id
  cidr_block = "10.0.3.0/24"

  map_public_ip_on_launch = true
  availability_zone = "ap-northeast-1c"
}

# internet gateway
resource "aws_internet_gateway" "example_gateway" {
  vpc_id = aws_vpc.example.id
}

# route_table public
resource "aws_route_table" "public_ap_northeast_a" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name = "example_ap_northeast_a"
  }
}
resource "aws_route_table" "public_ap_northeast_c" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name = "example_ap_northeast_c"
  }
}

# aws_route_table association public
resource "aws_route_table_association" "public_ap_northeast_a" {
  subnet_id = aws_subnet.public_ap_northeast_a.id
  route_table_id = aws_route_table.public_ap_northeast_a.id
}
resource "aws_route_table_association" "public_ap_northeast_c" {
  subnet_id = aws_subnet.public_ap_northeast_c.id
  route_table_id = aws_route_table.public_ap_northeast_c.id
}

# routing public
resource "aws_route" "public_ap_northeast_a" {
  route_table_id = aws_route_table.public_ap_northeast_a.id
  gateway_id = aws_internet_gateway.example_gateway.id
  destination_cidr_block = "0.0.0.0/0"
}
resource "aws_route" "public_ap_northeast_c" {
  route_table_id = aws_route_table.public_ap_northeast_a.id
  gateway_id = aws_internet_gateway.example_gateway.id
  destination_cidr_block = "0.0.0.0/0"
}

# private subnet
resource "aws_subnet" "private_ap_northeast_a" {
  vpc_id = aws_vpc.example.id
  cidr_block = "10.0.66.0/24"
  map_public_ip_on_launch = false
}

resource "aws_subnet" "private_ap_northeast_c" {
  vpc_id = aws_vpc.example.id
  cidr_block = "10.0.67.0/24"
  map_public_ip_on_launch = false
}

# aws_route_table private
resource "aws_route_table" "private_ap_northeast_a" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name = "private_route_table _ap_northeast_a"
  }
}
resource "aws_route_table" "private_ap_northeast_c" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name = "private_route_table _ap_northeast_c"
  }
}

# aws_route_table_association private
resource "aws_route_table_association" "private_private_ap_northeast_a" {
  subnet_id = aws_subnet.private_ap_northeast_a.id
  route_table_id = aws_route_table.private_ap_northeast_a.id
}
resource "aws_route_table_association" "private_ap_northeast_c"{
  subnet_id = aws_subnet.private_ap_northeast_c.id
  route_table_id = aws_route_table.private_ap_northeast_c.id
}

# aws_route private
resource "aws_route" "private_private_ap_northeast_a" {
  route_table_id = aws_route_table.private_ap_northeast_a.id
  nat_gateway_id = aws_nat_gateway.example_ap_northeast_a.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "private_private_ap_northeast_c" {
  route_table_id = aws_route_table.private_ap_northeast_c.id
  nat_gateway_id = aws_nat_gateway.example_ap_northeast_c.id
  destination_cidr_block = "0.0.0.0/0"
}

# aws_eip
resource "aws_eip" "nat_gateway_ap_northeast_a" {
  vpc = true
  depends_on = [aws_internet_gateway.example_gateway]
}

resource "aws_eip" "nat_gateway_ap_northeast_c" {
  vpc = true
  depends_on = [aws_internet_gateway.example_gateway]
}

# aws_nat_gateway
resource "aws_nat_gateway" "example_ap_northeast_a" {
  allocation_id = aws_eip.nat_gateway_ap_northeast_a.id
  subnet_id = aws_subnet.public_ap_northeast_a.id
  depends_on = [aws_internet_gateway.example_gateway]
}

resource "aws_nat_gateway" "example_ap_northeast_c" {
  allocation_id = aws_eip.nat_gateway_ap_northeast_c.id
  subnet_id = aws_subnet.public_ap_northeast_c.id
  depends_on = [aws_internet_gateway.example_gateway]
}
