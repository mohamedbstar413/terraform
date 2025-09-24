resource "aws_vpc" "book_vpc" {
  cidr_block =                  var.vpc_cidr
  enable_dns_hostnames =        true
  enable_dns_support =          true

  tags = {
    Name=                       "Book Review App VPC"
  }
}

resource "aws_internet_gateway" "book_igw" {
  vpc_id =                      aws_vpc.book_vpc.id
  tags = {
    Name =                      "Book App IGW"
  }
}

resource "aws_nat_gateway" "book_ngw" {
  subnet_id =                   aws_subnet.book_public_subnet_1
}


resource "aws_subnet" "book_public_subnet_1" {
  vpc_id =                      aws_vpc.book_vpc.id
  cidr_block =                  var.pub_subnet_1_cidr
  availability_zone =           var.az_1
  map_public_ip_on_launch =     true

  tags = {
    Name =                      "Book App Public Subnet"
  }
}

resource "aws_subnet" "book_private_subnet_1" {
  vpc_id =                      aws_vpc.book_vpc.id
  cidr_block =                  var.pri_subnet_1_cidr
  availability_zone =           var.az_1

  tags = {
    Name =                      "Book App Private Subnet 1"
  }
}

resource "aws_subnet" "book_private_subnet_2" {
  vpc_id =                      aws_vpc.book_vpc.id
  cidr_block =                  var.pri_subnet_2_cidr
  availability_zone =           var.az_2

  tags = {
    Name =                      "Book App Private Subnet 2"
  }
}

resource "aws_route_table" "book_private_route_table" {
  vpc_id =                      aws_vpc.book_vpc.id
  route {
    cidr_block =                var.vpc_cidr
    gateway_id =                "local"
  }
  route {
    cidr_block =                "0.0.0.0/0"
    gateway_id =                aws_nat_gateway.book_ngw.id
  }
}

resource "aws_route_table" "book_public_route_table" {
  vpc_id =                      aws_vpc.book_vpc.id
  route {
    cidr_block =                var.vpc_cidr
    gateway_id =                aws_internet_gateway.book_igw.id
  }
}

resource "aws_route_table_association" "book_pri_rt_assoc_1" {
  route_table_id =              aws_route_table.book_private_route_table.id
  subnet_id =                   aws_subnet.book_private_subnet_1
}

resource "aws_route_table_association" "book_pri_rt_assoc_2" {
  route_table_id =              aws_route_table.book_private_route_table.id
  subnet_id =                   aws_subnet.book_private_subnet_2
}

resource "aws_route_table_association" "book_pub_rt_assoc" {
  route_table_id =              aws_route_table.book_public_route_table
  subnet_id =                   aws_subnet.book_public_subnet_1
}
