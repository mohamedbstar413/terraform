resource "aws_db_subnet_group" "book_rds_subnet_group" {
  name =                        "rds-subnet-group"
  subnet_ids =                   [var.pri_subnet_1_id, var.pri_subnet_2_id]
}