data "aws_secretsmanager_secret" "db_password" {
  name = "book/rds/admin_password2"
}

data "aws_secretsmanager_secret_version" "db_password_version" {
  secret_id = data.aws_secretsmanager_secret.db_password.id
}