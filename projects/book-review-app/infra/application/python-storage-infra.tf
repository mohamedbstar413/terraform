resource "aws_s3_bucket" "python_app_s3_storage_bucket" {
  bucket =                  "book-review-python-app-s3-storage-bucket"
  force_destroy =           true
}


resource "aws_s3_object" "python_app_file" {
  bucket = aws_s3_bucket.python_app_s3_storage_bucket.id
  key    = "app.py"        # name of the file in the bucket
  source = "${path.root}/application/backend/app.py"        # path to the local file relative to directory
                                                            # where i run terraform apply

}

resource "aws_s3_bucket_public_access_block" "python_app_bucket_public_access" {
  bucket                  = aws_s3_bucket.python_app_s3_storage_bucket.id
  block_public_acls      = false
  block_public_policy    = false
  ignore_public_acls     = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket_policy" "python_app_bucket_policy" {
  bucket = aws_s3_bucket.python_app_s3_storage_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "AllowRead",
        Effect = "Allow",
        Principal = "*",
        Action = [
          "s3:*"
        ],
        Resource = "${aws_s3_bucket.python_app_s3_storage_bucket.arn}/*"
      }
    ]
  })
  depends_on = [
    aws_s3_bucket_public_access_block.python_app_bucket_public_access
  ]
}
