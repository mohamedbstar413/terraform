resource "aws_s3_bucket" "python_app_s3_storage_bucket" {
  bucket =                  "book-review-python-app-s3-storage-bucket"
}
#block public access to the bucket for security
resource "aws_s3_bucket_public_access_block" "my_bucket_block" {
  bucket = aws_s3_bucket.python_app_s3_storage_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "python_app_file" {
  bucket = aws_s3_bucket.python_app_s3_storage_bucket.id
  key    = "app.py"        # name of the file in the bucket
  source = "application/backend/app.py"        # path to the local file relative to directory
                                    # where i run terraform apply
  acl    = "private"
}