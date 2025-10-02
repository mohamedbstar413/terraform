resource "aws_db_instance" "book_rds_isntance" {
  allocated_storage =           var.book_rds_storage
  db_name=                      var.db_name
  engine =                      var.db_engine
  instance_class=               var.instance_class
  username =                    var.db_username
  password =                    var.db_password
  db_subnet_group_name =        aws_db_subnet_group.book_rds_subnet_group.name
  vpc_security_group_ids =      [aws_security_group.rds_sg.id]
}

resource "aws_security_group" "rds_sg" {
  vpc_id =                       var.vpc_id

  ingress {
    from_port =                   var.db_port
    to_port =                     var.db_port
    protocol =                    "tcp"
    security_groups =             [var.back_ec2_sg_id] #allow connection to database 
                                                        #only from backend instances
  }
}