provider "aws" {
  region = "us-east-1"
}

#create a vpc
resource "aws_vpc" "main_vpc" {
  cidr_block =                  "10.0.0.0/16"
  enable_dns_support =          true
  enable_dns_hostnames =        true

  tags = {
    Name =                      "main vpc"
  }
}

#create an internet gateway
resource "aws_internet_gateway" "main_igw" {
  vpc_id =                      aws_vpc.main_vpc.id
  tags = {
    Name =                      "main vpc"
  }
}

#create a subnet
resource "aws_subnet" "public_subnet" {
  vpc_id =                       aws_vpc.main_vpc.id
  availability_zone =            "us-east-1a"
  cidr_block =                   "10.0.1.0/24"
  map_public_ip_on_launch =      true   #force instances in this subnet take a public ip upon launch
  tags = {
    Name =                       "public subnet"
  }
}

#create a route table for the subnet
resource "aws_route_table" "public_route_table" {
  vpc_id =                        aws_vpc.main_vpc.id

  route {
    cidr_block =                  "10.0.0.0/16"
    gateway_id =                  "local"
  }

  route {
    cidr_block =                  "0.0.0.0/0"
    gateway_id =                  aws_internet_gateway.main_igw.id
  }
}

#attach the subnet to the public route table
resource "aws_route_table_association" "public_route_table_assoc" {
    route_table_id =              aws_route_table.public_route_table.id
    subnet_id =                   aws_subnet.public_subnet.id
}

#create a security group for instances inside this subnet
resource "aws_security_group" "allow_http_ssh_sg" {
  vpc_id =                        aws_vpc.main_vpc.id

  ingress {
    from_port =                   22
    to_port =                     22
    protocol =                    "tcp"
    cidr_blocks =                 ["0.0.0.0/0"]
  }

  ingress {
    from_port =                   80
    to_port =                     80
    protocol =                    "tcp"
    cidr_blocks =                 ["0.0.0.0/0"]
  }

  egress {
    from_port =                   0
    to_port =                     0
    protocol =                    "-1"
    cidr_blocks =                 ["0.0.0.0/0"]
  }
}

resource "aws_instance" "first_instance" {
  subnet_id =                     aws_subnet.public_subnet.id
  ami =                           "ami-0d85d4f07a62e2969"
  associate_public_ip_address =   true
  instance_type =                 "t3.micro"
  security_groups =               [aws_security_group.allow_http_ssh_sg.id]
  key_name =                      "new-key"
  tags = {
    Name =                        "first instance"
  }
}

resource "aws_instance" "second_instance" {
  subnet_id =                     aws_subnet.public_subnet.id
  ami =                           "ami-0d85d4f07a62e2969"
  associate_public_ip_address =   true
  instance_type =                 "t3.micro"
  security_groups =               [aws_security_group.allow_http_ssh_sg.id]
  key_name =                      "new-key"
  tags = {
    Name =                        "second instance"
  }
}