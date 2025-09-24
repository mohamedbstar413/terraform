resource "aws_lb_target_group" "book_back_ec2_target_group" {
  vpc_id =                      aws_vpc.book_vpc.id
  port =                        var.http_port
  protocol =                    "HTTP"

  tags = {
    Name =                      "Book Backend EC2 Target Group"
  }
}
