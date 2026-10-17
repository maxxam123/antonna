output "s3_bucket_id" {
  description = "The name of the bucket."
  value       = aws_s3_bucket.this.id
}

output "s3_bucket_arn" {
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
  value       = aws_s3_bucket.this.arn
}

output "s3_bucket_domain_name" {
  description = "The bucket domain name. Will be of format ://amazonaws.com."
  value       = aws_s3_bucket.this.bucket_domain_name
}
