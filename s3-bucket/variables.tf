#S3 Variables
variable "cf_logging_bucket_name" {
  description = "S3 Bucket Name"
  type        = string
}
variable "create_bucket" {
  default = "test.txt"
}