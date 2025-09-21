resource "aws_vpc" "my_vpc" {
  cidr_block =              "10.0.0.0/16"
}

resource "aws_internet_gateway" "my_igw" {
    vpc_id =                aws_vpc.my_vpc.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id =                  aws_vpc.my_vpc.id

  route {
    cidr_block =            "10.0.0.0/16"
    gateway_id =            "local"
  }

  route {
    cidr_block =            "0.0.0.0/0"
    gateway_id =            aws_internet_gateway.my_igw.id
  }

}

resource "aws_subnet" "public_subnet" {
  vpc_id =                  aws_vpc.my_vpc.id
  cidr_block =              "10.0.1.0/24"
  availability_zone =       "us-east-1a"
  map_public_ip_on_launch = true
}