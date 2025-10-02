//variables for backend module
variable "vpc_cidr" {
  type = string
}
variable "az_1" {
  type = string
}
variable "az_2" {
  type = string
}
variable "instance_type" {
  type = string
}
variable "pub_subnet_1_cidr" {
  type = string
}
variable "pri_subnet_1_cidr" {
  type = string
}
variable "pri_subnet_2_cidr" {
  type = string
}
variable "asg_desired_size" {
  type = number
}
variable "asg_max_size" {
  type = number
}
variable "asg_min_size" {
  type = number
}

//variables for db module
variable "book_rds_storage" {
  type = number
}
variable "db_port" {
  type = number
}
variable "db_username" {
  type = string
}
variable "db_password" {
  type = string
}

variable "db_engine" {
  type = string
}
variable "db_name" {
  type = string
}