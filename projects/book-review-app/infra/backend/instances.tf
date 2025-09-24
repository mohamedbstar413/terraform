resource "aws_instance" "book_public_bastion_instance" {
  subnet_id =                       aws_subnet.book_public_subnet_1.id
  instance_type =                   var.instance_type
  ami =                             data.aws_ami.ubuntu_image

  key_name =                        "new-key"

  tags = {
    Name =                          "Bastion instance"
  }
}

resource "aws_security_group" "back_ec2_sg" {
  vpc_id =                          aws_vpc.book_vpc.id

  ingress {
    from_port =                     var.http_port
    to_port =                       var.http_port

    protocol =                      "tcp"
    security_groups =               [aws_security_group.book_front_lb_sg.id] #only allow http from the load balancer

  }

  ingress {
    from_port =                     var.ssh_port
    to_port =                       var.ssh_port

    protocol =                      "tcp"
    cidr_blocks =                   [var.vpc_cidr] #allow ssh for debugging
  }
  egress {
    from_port =                     0
    to_port =                       0
    protocol =                      "-1"
    cidr_blocks =                   ["0.0.0.0/0"]
  }
}