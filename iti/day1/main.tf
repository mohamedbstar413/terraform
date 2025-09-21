provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "my_vpc" {
  cidr_block =              "10.0.0.0/16"
  enable_dns_support =      true
  enable_dns_hostnames =    true
  tags = {
    Name = "iti-day1-vpc"
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "iti-day1-igw"
  }
}
resource "aws_egress_only_internet_gateway" "my_egw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my-egw"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id =                  aws_vpc.my_vpc.id
  cidr_block =              "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone =       "us-east-1a"

  tags = {
    Name = "iti-day1-public-subnet"
  }
}

resource "aws_route_table" "my_route_table" {
  vpc_id =                  aws_vpc.my_vpc.id

  route {
    cidr_block =            "0.0.0.0/0"
    gateway_id =            aws_internet_gateway.my_igw.id
  }

  route {
    ipv6_cidr_block =       "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.my_egw.id
  }

  tags = {
    Name = "iti-day1-route-table"
  }
}

resource "aws_route_table_association" "my_rta" {
  subnet_id =               aws_subnet.my_subnet.id
  route_table_id =          aws_route_table.my_route_table.id
}


resource "aws_security_group" "my_sg" {
  vpc_id =                  aws_vpc.my_vpc.id
  description =             "Allow HTTP and SSH"
  name =                    "http-sg"

  ingress {
    description =            "Allow SSH"
    from_port =              22
    to_port =                22
    protocol =               "tcp"
    cidr_blocks =            ["0.0.0.0/0"]
  }

  ingress {
    description =             "Allow HTTP"
    from_port =               80
    to_port =                 80
    protocol =                "tcp"
    cidr_blocks =             ["0.0.0.0/0"]
  }

  egress {
    description =             "Allow all outbound traffic"
    from_port =               0
    to_port =                 0
    protocol =                "-1"
    cidr_blocks =             ["0.0.0.0/0"]
  }
}

#ami: ami-0d85d4f07a62e2969

resource "aws_instance" "my_ec2" {
  ami =                     "ami-0d85d4f07a62e2969"
  instance_type =           "t3.micro"
  subnet_id =               aws_subnet.my_subnet.id
  vpc_security_group_ids =  [aws_security_group.my_sg.id]
  associate_public_ip_address = true
  availability_zone =       "us-east-1a"

  key_name =                "new-key"

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl enable httpd
              systemctl start httpd
              echo "<h1>Hello from Apache on EC2 in Terraform VPC</h1>" > /var/www/html/index.html
              EOF
    tags = {
      Name = "iti-instance"
    }
}

output "ec2_public_ip" {
  value = aws_instance.my_ec2.public_ip
}