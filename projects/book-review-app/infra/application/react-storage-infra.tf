resource "aws_s3_bucket" "react_app_s3_storage_bucket" {
  bucket =                  "book-review-react-app-s3-storage-bucket"
}

resource "aws_s3_bucket_website_configuration" "react_website" {
  bucket = aws_s3_bucket.react_app_s3_storage_bucket.id
  depends_on = [ var.front_lb ] #create only after front lb is up and running
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"  # React router fallback
  }
}

resource "aws_s3_bucket_public_access_block" "react_app_block" {
  bucket                  = aws_s3_bucket.react_app_s3_storage_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

#Allow Public access to the website
resource "aws_s3_bucket_policy" "react_app_policy" {
  bucket = aws_s3_bucket.react_app_s3_storage_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = "${aws_s3_bucket.react_app_s3_storage_bucket.arn}/*"
      }
    ]
  })
}

#uploading build files

locals {
  files = fileset("application/frontend/build/", "**")
}

resource "aws_s3_object" "react_build" {
  for_each = local.files

  bucket       = aws_s3_bucket.react_app_s3_storage_bucket.id
  key          = each.value
  source       = "application/frontend/build/${each.value}"
  content_type = lookup({
    html = "text/html",
    css  = "text/css",
    js   = "application/javascript",
    json = "application/json",
    png  = "image/png",
    jpg  = "image/jpeg",
    svg  = "image/svg+xml",
    txt  = "text/plain"
  }, split(".", each.value)[length(split(".", each.value)) - 1], "binary/octet-stream")
}


output "react_website_url" {
  value = aws_s3_bucket_website_configuration.react_website.website_endpoint
}
