terraform {
  backend "s3" {
    bucket         = "book-review-terraform-state-backend-bucket"
    key            = "path/to/my/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "book-review-terraform-lock-table"
  }
}
