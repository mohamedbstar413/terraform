module "backend"{
    source = "./backend"
    vpc_cidr = var.vpc_cidr
    pub_subnet_1_cidr = var.pub_subnet_1_cidr
    pri_subnet_1_cidr = var.pri_subnet_1_cidr
    pri_subnet_2_cidr = var.pri_subnet_2_cidr
    az_1 = var.az_1
    az_2 = var.az_2
    instance_type = var.instance_type
    asg_desired_size = var.asg_desired_size
    asg_max_size = var.asg_max_size
    asg_min_size = var.asg_min_size
}
module "db" {
  source = "./db"
  book_rds_storage = var.book_rds_storage
  db_port = var.db_port
  db_username = var.db_username
  db_password = var.db_password
  vpc_id = module.backend.vpc_id
  pri_subnet_1_id = module.backend.pri_subnet_1_id
  pri_subnet_2_id = module.backend.pri_subnet_2_id
  back_ec2_sg_id = module.backend.back_ec2_sg_id
  db_engine = var.db_engine
  db_name = var.db_name
}
