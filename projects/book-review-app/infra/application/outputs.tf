output "python_s3" {
  value = aws_s3_object.python_app_file
}

output "react_s3_dns" {
  value = aws_s3_bucket.react_app_s3_storage_bucket.bucket_regional_domain_name
}