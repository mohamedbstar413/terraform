#make an internet gateway for the pubilc subnet
resource "aws_internet_gateway" "iti-igw" {
    vpc_id =                        aws_vpc.iti_vpc.id
}

resource "aws_eip" "iti-eip" {
    domain =                        "vpc"
}

resource "aws_nat_gateway" "iti-natgw" {
    subnet_id =                     aws_subnet.iti-subnets[0].id
    allocation_id =                 aws_eip.iti-eip.id
}

#resource "aws_nat_gateway_eip_association" "iti-nat-eip" {
#    allocation_id =                 aws_eip.iti-eip.id
#    nat_gateway_id =                aws_nat_gateway.iti-natgw.id
#}