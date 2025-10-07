resource "aws_lb" "book_front_lb" {
  name =                    "book-front-lb"
  internal =                false
  load_balancer_type =      "application"
  security_groups =         [aws_security_group.book_front_lb_sg.id]

  subnets =                 [aws_subnet.book_private_subnet_1.id, aws_subnet.book_private_subnet_2.id]
  
  provisioner "local-exec" {
    command = "echo ${self.dns_name} > ../application/frontend/lb_dns.txt"
  }
  tags = {
    Name =                  "Front Load Balancer"
  } 
}

resource "aws_lb_listener" "book_front_lb_http_listener" {
  load_balancer_arn =       aws_lb.book_front_lb.arn
  port =                    var.http_port
  protocol =                "HTTP"

  default_action {
    type =                  "forward"
    target_group_arn =      aws_lb_target_group.book_back_ec2_target_group.arn
  } 
  tags = {
    Name =                  "Front Load Balancer HTTP Listener"
  }
}

resource "aws_security_group" "book_front_lb_sg" {
  vpc_id =                  aws_vpc.book_vpc.id
  #allow all inbound traffic at port 80
  ingress {
    from_port =             var.http_port
    to_port =               var.http_port
    protocol =              "tcp"
    cidr_blocks =           ["0.0.0.0/0"]
  }

  #allow all outbound traffic
  egress {
    from_port =             0
    to_port =               0
    protocol =              "-1"
    cidr_blocks =           ["0.0.0.0/0"]
  }
}