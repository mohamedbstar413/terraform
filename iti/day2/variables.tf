

variable "subnets" {
    description = "Holding names of the subnets"
    type = list
}

variable "cidr_blocks" {
    description = "Holding values for subnets cidr_block"
    type = list
}

variable "public-cidrs" {
    type = list
}
variable "private-cidrs" {
    type = list
}
variable "http-port" {
    type = number
    default = 80
}
variable "ssh-port" {
    type = number
    default = 22
}

variable "ami_id" {
    default = "ami-0d85d4f07a62e2969"
}