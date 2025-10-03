resource "aws_s3_bucket" "python_app_s3_storage_bucket" {
  bucket =                  "book_review_python_app_s3_storage_bucket"
}
#block public access to the bucket for security
resource "aws_s3_bucket_public_access_block" "my_bucket_block" {
  bucket = aws_s3_bucket.python_app_s3_storage_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}