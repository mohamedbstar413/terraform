output "eip_ip" {
    value = aws_eip.iti-eip.public_ip
}


output "private-instance-private-ip" {
    value = "override"
}