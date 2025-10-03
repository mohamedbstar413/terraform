output "bastion_public_instance" {
  value = aws_instance.book_public_bastion_instance.public_ip
}

output "vpc_id" {
  value = aws_vpc.book_vpc.id
}
output "pri_subnet_1_id" {
  value = aws_subnet.book_private_subnet_1.id
}
output "pri_subnet_2_id" {
  value = aws_subnet.book_private_subnet_2.id
}
output "back_ec2_sg_id" {
  value = aws_security_group.back_ec2_sg.id
}

output "front_lb_dns" {
  value = aws_lb.book_front_lb.dns_name
}