resource "aws_instance" "instance_proxy_1" {
    ami =                               data.aws_ami.ubuntu_ami.id
    instance_type =                     var.isntance_type
    subnet_id =                         var.pub_subnet_1_id
    key_name =                          "new-key"
    vpc_security_group_ids =            [aws_security_group.proxy_instances_sg.id]

    user_data = <<-EOF
            #!/bin/bash
            apt-get update -y
            apt-get install -y nginx
            
            sudo systemctl start nginx
            sudo systemctl enable nginx
            echo "Hello From Proxy Server 1" | tee /var/www/html/index.html
            sudo systemctl restart nginx
        EOF

    tags = {
        Name=                           "Proxy 1 instance"
    }
}

resource "aws_instance" "instance_proxy_2" {
    ami =                               data.aws_ami.ubuntu_ami.id
    instance_type =                     var.isntance_type
    subnet_id =                         var.pub_subnet_2_id
    
    vpc_security_group_ids =            [aws_security_group.proxy_instances_sg.id]
    key_name =                          "new-key"

    user_data = <<-EOF
            #!/bin/bash
            apt-get update -y
            apt-get install -y nginx
            
            sudo systemctl start nginx
            sudo systemctl enable nginx
            echo "Hello From Proxy Server 2" | tee /var/www/html/index.html
            sudo systemctl restart nginx
        EOF
    tags = {
        Name=                           "Proxy 2 instance"
    }
}

resource "aws_security_group" "proxy_instances_sg" {
    vpc_id =                            var.vpc_id
    ingress {
        #allow ssh from anywhere
        from_port =                     22
        to_port =                       22
        protocol =                      "tcp"
        cidr_blocks =                   ["0.0.0.0/0"]
    }
    ingress {
        #allow http traffic only from load balancer
        from_port =                     80
        to_port =                       80
        protocol =                      "tcp"
        security_groups =               [var.front_lb_sg_id] #from load balancer security group only
    }

    egress {
        from_port =                     0
        to_port =                       0
        protocol =                      "-1"
        cidr_blocks =                   ["0.0.0.0/0"]
    }
}