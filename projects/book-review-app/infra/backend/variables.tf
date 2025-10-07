variable "vpc_cidr" {
  type = string
}
variable "pri_subnet_1_cidr" {
  type = string
}

variable "pri_subnet_2_cidr" {
  type = string
}

variable "pub_subnet_1_cidr" {
  type = string
}

variable "az_1" {
  type = string
}
variable "az_2" {
  type = string
}

variable "http_port" {
  type = number
  default = 80
}
variable "ssh_port" {
  type = number
  default = 22
}

variable "instance_type" {
  type = string
}
variable "asg_max_size" {
  type = number
}
variable "asg_min_size" {
  type = number
}
variable "asg_desired_size" {
  type = number
}

variable "back_ec2_instance_profile_name" {
  type = string
}

variable "book_review_added_sns_topic_arn" {
  type = string
}
variable "python_s3" {
  type = object({
    arn    = string
    bucket = string
    id     = string
  })
}
