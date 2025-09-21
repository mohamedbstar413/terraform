resource "aws_security_group" "private-sg" {
    vpc_id =                    aws_vpc.iti_vpc.id

    ingress {
        from_port =             var.ssh-port
        to_port =               var.ssh-port
        protocol =              "tcp"
        cidr_blocks =           var.private-cidrs
    }
    ingress {
        from_port =             var.http-port
        to_port =               var.http-port
        protocol =              "tcp"
        cidr_blocks =           var.private-cidrs
    }
}
resource "aws_security_group" "pubilc-sg" {
    vpc_id =                    aws_vpc.iti_vpc.id

    ingress {
        from_port =             var.ssh-port
        to_port =               var.ssh-port
        protocol =              "tcp"
        cidr_blocks =           var.public-cidrs
    }
    ingress {
        from_port =             var.http-port
        to_port =               var.http-port
        protocol =              "tcp"
        cidr_blocks =           var.public-cidrs
    }
}


resource "aws_instance" "private-instance" {
    ami =                       var.ami_id
    subnet_id =                 aws_subnet.iti-subnets[1].id
    instance_type =             "t3.micro"

    vpc_security_group_ids =    [aws_security_group.private-sg.id]
    key_name =                  "new-key"
    user_data = <<EOF
        sudo yum update -y
        sudo yum install -y httpd
        sudo systemctl start httpd.service
        sudo systemctl enable httpd.service

        echo "Hello From Terraform" | cat > /var/www/html
    EOF
}

resource "aws_instance" "pubilc-instance" {
    ami =                       var.ami_id
    subnet_id =                 aws_subnet.iti-subnets[0].id
    instance_type =             "t3.micro"

    vpc_security_group_ids =    [aws_security_group.pubilc-sg.id]
    key_name =                  "new-key"

    user_data = <<EOF
        sudo yum update -y
        sudo yum install -y httpd
        sudo systemctl start httpd.service
        sudo systemctl enable httpd.service

        echo "Hello From Terraform" | cat > /var/www/html
    EOF
    tags = {
      Name = "My public"
    }
}
