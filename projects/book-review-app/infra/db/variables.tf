variable "pri_subnet_1_id" {
  type = string
}

variable "pri_subnet_2_id" {
  type = string
}

variable "book_rds_storage" {
  type = number
}
variable "db_engine" {
  type = string
}
variable "db_name" {
  type = string
}
variable "instance_class" {
  type = string
  default = "db.t3.micro"
}

variable "db_username" {
  type = string
}
variable "db_password" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "db_port" {
  type = number
}

variable "back_ec2_sg_id" {
  type = string
}