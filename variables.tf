# Global Variables
variable "aws_region" {
  description = "AWS Region for deploying resources"
  type        = string
  default     = "us-east-1"
}

variable "cliente" {
  description = "Nome do Cliente, base para nomear os recursos"
  type        = string
}

variable "alb_acm_certificate_arn" {
  description = "ARN of the ACM certificate for custom domain name"
  type        = string
}

variable "zone_id" {
  description = "Route53 ZoneID"
  type        = string 
}