resource "null_resource" "cf_dashboard" {
  triggers = {
    build = timestamp()
    app_name = var.urlname
  }
  depends_on = [time_sleep.wait_30_seconds]
  provisioner "local-exec" {
    working_dir = path.module
    command     = "aws cloudformation deploy --template-file dashboard.yaml --s3-bucket ${var.cf_logging_bucket_s3_name} --capabilities CAPABILITY_NAMED_IAM --parameter-overrides CFDistributionID=${aws_cloudfront_distribution.trt_distribution.id} CFLogPrefixParameter=${var.domain_name} ContributorInsightRuleState=ENABLED NotificationBucket=${var.cf_logging_bucket_s3_name} CFDashboardName=${var.urlname} --stack-name dashboard-${var.urlname} --region us-east-1"
  }

  provisioner "local-exec" {
    when        = destroy
    working_dir = path.module
    command     = "aws cloudformation delete-stack --stack-name dashboard-${self.triggers.app_name} --region us-east-1" 
  }
  
  lifecycle {
  ignore_changes = all
}
  
}


resource "time_sleep" "wait_30_seconds" {
   create_duration = "30s"
}

