data "aws_s3_bucket" "check" {
  bucket = var.cf_logging_bucket_name
}
locals {
  bucket_present = anytrue([
	for bucket in data.aws_s3_bucket.check: bucket == var.create_bucket
  ])
}
output "bucket" {
  value = data.aws_s3_bucket.check
}
resource "aws_s3_bucket" "cf_logging_bucket" {
  count  = local.bucket_present ? 1 : 0
  bucket = var.cf_logging_bucket_name
}