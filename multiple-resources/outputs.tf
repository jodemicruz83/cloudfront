output "distribution_domain_name" {
  value       = aws_cloudfront_distribution.trt_distribution.domain_name
  description = "Cloudfront distribution domain name"
}

# output "cache_policy_id" {
#   value       = aws_cloudfront_cache_policy.cf_cache_policy.id
#   description = "Cloudfront origin cache policy ID"
# }

# output "origin_request_policy_id" {
#   value       = aws_cloudfront_origin_request_policy.cf_origin_request_policy.id
#   description = "Cloudfront origin request policy ID"
# }
output "web_acl_arn" {
  value       = aws_wafv2_web_acl.web_acl.arn
  description = "WAF Web ACL ARN"
}

output "aws_cloudwatch_log_group_arn" {
  value       = aws_cloudwatch_log_group.aws_waf_logs.arn
  description = "WAF log grourps ARN"
}