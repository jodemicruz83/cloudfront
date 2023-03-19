locals {
  urls = csvdecode(file("${path.module}/url.csv"))
}

module "multi" {
    source = "./multiple-resources"
    
    for_each = {for url in local.urls : url.url => url}
    
    aws_region                  = var.aws_region
    policy_name                 = format("%s%s","policy-",replace(each.value.url, ".","-"))
    lifecycle_environment       = format("%s%s",each.value.url,"-prod")
    cf_logging_bucket           = format("%s%s%s","cloudfront-logging-",var.cliente,".s3.amazonaws.com") #"cloudfront-logging-trtxx.s3.amazonaws.com"
    cf_logging_bucket_s3_name   = format("%s%s","cloudfront-logging-",var.cliente) # Usado pelo Cloudformation
    alb_acm_certificate_arn     = var.alb_acm_certificate_arn
    application_name            = each.value.url
    domain_name                 = format("%s%s","origin-",each.value.url)
    cname                       = each.value.url
    alter_domain_name           = each.value.url #Colocar no CSV e botar condicional
    urlip                       = each.value.ip
    urlname                     = each.value.name
    cliente                     = var.cliente
    zone_id                     = var.zone_id
}

module "s3_bucket" {
  source                    = "./s3-bucket"
  cf_logging_bucket_name    = format("%s%s","cloudfront-logging-",var.cliente) #"cloudfront-logging-trtXX"
  
}
