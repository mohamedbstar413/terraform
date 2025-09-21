resource "aws_vpc" "iti_vpc" {
  cidr_block =                      "10.0.0.0/16"
  enable_dns_hostnames =            true
  enable_dns_support =              true
  tags = {
    Name =                          "Iti vpc"
  }
}

resource "aws_subnet" "iti-subnets" {
    vpc_id =                        aws_vpc.iti_vpc.id
    count =                         length(var.subnets)
    cidr_block =                    var.cidr_blocks[count.index]
    availability_zone =             "us-east-1a"
    map_public_ip_on_launch =       count.index == 0? true : false
    tags = {
        Name =                      var.subnets[count.index]
    }
}
