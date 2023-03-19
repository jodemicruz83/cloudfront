# resource "aws_cloudfront_cache_policy" "cf_cache_policy" {

#   name                      = format("%s%s","policy-",replace(var.urlname, ".","-")) #replace("1 + 2 + 3", "+", "-")
#   comment                   = "Cache policy for TRT cloudfront"
#   default_ttl               = 86400
#   max_ttl                   = 31536000
#   min_ttl                   = 1

#   parameters_in_cache_key_and_forwarded_to_origin {

#     enable_accept_encoding_brotli = true
#     enable_accept_encoding_gzip   = true
#     headers_config {
#       header_behavior = "none"
# #      headers {
# #        items = [
# #          "Authorization",
# #          "Origin",
# #          "Host",
# #          "access-control-allow-origin",
# #          "Accept",
# #          "Access-Control-Request-Method",
# #          "Access-Control-Request-Headers",
# #          "Referer",
# #          "x-access-token"
# #        ]
# #      }
#     }

#     query_strings_config {
#       query_string_behavior = "all"
#     }

#     cookies_config {
#       cookie_behavior = "whitelist"
#         cookies {
#           items = ["politica-de-privacidade"]
#       }
#     }

#   }
# }
# resource "aws_cloudfront_origin_request_policy" "cf_origin_request_policy" {
#   name    = var.policy_name
#   comment = "Request policy for TRT cloudfront"
#   cookies_config {
#     cookie_behavior = "all"
#   }
#   headers_config {
#     header_behavior = "allViewer"
#   }
#   query_strings_config {
#     query_string_behavior = "all"
#   }
# }
resource "aws_cloudwatch_log_group" "aws_waf_logs" {
  name = format("%s%s","aws-waf-logs-",var.urlname) 
  retention_in_days = "731"
  
}
resource "aws_wafv2_web_acl_logging_configuration" "waf_logging_configuration" {
  log_destination_configs = [aws_cloudwatch_log_group.aws_waf_logs.arn]
  resource_arn            = aws_wafv2_web_acl.web_acl.arn
  depends_on              = [aws_cloudwatch_log_group.aws_waf_logs]
}
resource "aws_wafv2_web_acl" "web_acl" {
  name        = format("%s%s","WAF_CF_WEB_ACL_",var.urlname)  
  description = "ACL for Backend/Frontend applications"
  scope       = "CLOUDFRONT"

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = format("%s%s","WAF_CF_WEB_ACL_",var.urlname) 
    sampled_requests_enabled   = true
  }

  default_action {
    allow {}
  }


  #50 - AWSManagedRulesBotControlRuleSet
  rule {
    name     = "AWS-AWSManagedRulesBotControlRuleSet"
    priority = 1

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesBotControlRuleSet"
        vendor_name = "AWS"
        
          excluded_rule {
              name = "CategorySocialMedia"
          }
          excluded_rule {
              name = "SignalNonBrowserUserAgent"
          }
        
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesBotControlRuleSet"
      sampled_requests_enabled   = true
    }
  }
  
  #25 - Amazon IP reputation list
  rule {
    name     = "AWS-AWSManagedRulesAmazonIpReputationList"
    priority = 2

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesAmazonIpReputationList"
      sampled_requests_enabled   = true
    }
  }
  
  #50 - Anonymous IP List
  rule {
    name     = "AWS-AWSManagedRulesAnonymousIpList"
    priority = 3

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAnonymousIpList"
        vendor_name = "AWS"
        
          excluded_rule {
              name = "HostingProviderIPList"
          }
        
        
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesAnonymousIpList"
      sampled_requests_enabled   = true
    }
  }
  
  #200 - Known bad inputs
  rule {
    name     = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
    priority = 4

    override_action {
      count {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesKnownBadInputsRuleSet"
      sampled_requests_enabled   = true
    }
  }
  
  #200 - Linux operating system
  rule {
    name     = "AWS-AWSManagedRulesLinuxRuleSet"
    priority = 5

    override_action {
      count {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesLinuxRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesLinuxRuleSet"
      sampled_requests_enabled   = true
    }
  }
  
  #200 - SQL database
  rule {
    name     = "AWS-AWSManagedRulesSQLiRuleSet"
    priority = 6

    override_action {
      count {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesSQLiRuleSet"
      sampled_requests_enabled   = true
    }
  }
  
  #700 - Core rule set
  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 8

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }
  
}
##Comentado Jodemi para testes TRT7
resource "aws_route53_record" "origin_route53_entry" {
  zone_id = var.zone_id
  name    = var.domain_name
  type    = "A"
  ttl     = 300
  records = [var.urlip]
}
resource "aws_cloudfront_distribution" "trt_distribution" {

  depends_on = [
    aws_wafv2_web_acl.web_acl
  ]
  
  comment         = format("%s%s","Cloudfront distribution for ",var.cliente) 
  price_class     = "PriceClass_All"
  enabled         = true
  is_ipv6_enabled = true
  web_acl_id      =  aws_wafv2_web_acl.web_acl.arn
  
  
  viewer_certificate {
    acm_certificate_arn      = var.alb_acm_certificate_arn
    iam_certificate_id = ""
    cloudfront_default_certificate = false
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }
  
  
  aliases = [
    var.cname, var.alter_domain_name
  ]



  origin {
  
    origin_id   = var.application_name
    domain_name = format("%s%s","origin-",var.cname) 

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "match-viewer"
      origin_ssl_protocols = [
        "TLSv1.2"
      ]
    }
  }

  default_cache_behavior {
    cache_policy_id          = "3b99be52-d30d-4821-a23e-a2aa2d4427aa"
    #cache_policy_id          = aws_cloudfront_cache_policy.cf_cache_policy.id   #var.cache_policy_id
    origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
    #origin_request_policy_id = aws_cloudfront_origin_request_policy.cf_origin_request_policy.id #var.origin_request_policy_id
    target_origin_id         = var.application_name
    viewer_protocol_policy   = "redirect-to-https"
    compress                 = true
    allowed_methods = [
      "GET",
      "HEAD",
      "OPTIONS",
      "PUT",
      "POST",
      "PATCH",
      "DELETE"
    ]

    cached_methods = [
      "GET",
      "HEAD"
    ]
  }
  
  # Cache para jpg,png,gif e js
  #   ordered_cache_behavior {
  #   path_pattern     = "*.jpg"
  #   allowed_methods  = ["GET", "HEAD", "OPTIONS"]
  #   cached_methods   = ["GET", "HEAD", "OPTIONS"]
  #   target_origin_id = lvar.application_name
  #   compress                 = true
  #   forwarded_values {
  #     query_string = false
  #     headers      = ["Origin"]

  #     cookies {
  #       forward = "none"
  #     }
  #   }

  #   min_ttl                = 0
  #   default_ttl            = 86400
  #   max_ttl                = 31536000
  #   compress               = true
  #   viewer_protocol_policy = "redirect-to-https"
  # }
  
  
  
  restrictions {
    geo_restriction {
      restriction_type = "blacklist"
      locations        = ["RU", "BY", "CN"]
    }
  }

  logging_config {
    bucket = var.cf_logging_bucket
    prefix = var.application_name
  }
  
  # lifecycle {
  #   ignore_changes = [
  #   ordered_cache_behavior,
  #   default_cache_behavior
  #   ]
  #   }
}