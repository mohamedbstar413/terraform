resource "aws_lb" "book_front_lb" {
  name =                    "book_front_lb"
  internal =                false
  load_balancer_type =      "application"
  security_groups =         [aws_security_group.book_front_lb_sg.id]

  subnets =                 [aws_subnet.book_public_subnet_1.id]
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
    target_group_arn =      ""
  } 
  tags = {
    Name =                  "Front Load Balancer HTTP Listener"
  }
}

resource "aws_security_group" "book_front_lb_sg" {
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