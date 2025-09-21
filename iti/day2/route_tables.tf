
#create a route table for each subnet
resource "aws_route_table" "pubilc-rt" {
    vpc_id =                        aws_vpc.iti_vpc.id
    route {
        cidr_block =                "0.0.0.0/0"
        gateway_id =                aws_internet_gateway.iti-igw.id
    }
    route {
        cidr_block =                "10.0.0.0/16"
        gateway_id =                "local"
    }
}

resource "aws_route_table" "private-rt" {
    vpc_id =                        aws_vpc.iti_vpc.id
    route {
        cidr_block =                "0.0.0.0/0"
        gateway_id =                aws_nat_gateway.iti-natgw.id
    }
    route {
        cidr_block =                "10.0.0.0/16"
        gateway_id =                "local"
    }
}

resource "aws_route_table_association" "iti-public-rt-assoc" {
    route_table_id =                aws_route_table.pubilc-rt.id
    subnet_id =                     aws_subnet.iti-subnets[0].id
}

resource "aws_route_table_association" "iti-private-rt-assoc" {
    route_table_id =                aws_route_table.private-rt.id
    subnet_id =                     aws_subnet.iti-subnets[1].id
}