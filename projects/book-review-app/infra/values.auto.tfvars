//values for backend module variables
vpc_cidr = "10.0.0.0/16"
pub_subnet_1_cidr = "10.0.0.0/24"
pri_subnet_1_cidr = "10.0.1.0/24"
pri_subnet_2_cidr = "10.0.2.0/24"
az_1 = "us-east-1a"
az_2 = "us-east-1b"
instance_type = "t3.micro"
asg_desired_size = 2
asg_min_size = 2
asg_max_size = 5


//values for db module variables

book_rds_storage = 10
db_port = 3306
db_engine = "mysql"
db_name = "bookDb"