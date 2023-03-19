# Material de referência sobre os IPs utilizados nas CDNs na AWS.: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/LocationsOfEdgeServers.html
# Arquivo JSON com a lista de IPs das CDNs na AWS.: https://d7uri8nf7uskq.cloudfront.net/tools/list-cloudfront-ips
# # Referência
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CWL_QuerySyntax.html
# https://aws.amazon.com/pt/premiumsupport/knowledge-center/waf-analyze-logs-stored-cloudwatch-s3/
# https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-baseline.html

# 01 - Default
resource "aws_cloudwatch_query_definition" "Default" {
  name = "Default"

  log_group_names = [
    "/aws/logGroup1",
    "/aws/logGroup2"
  ]

  query_string = <<EOF
fields @timestamp, @message
| sort @timestamp desc
| limit 20
EOF
}
resource "aws_cloudwatch_query_definition" "consulta" {
  name = "Consulta de BLOCK por IP"

  log_group_names = [
    "/aws/logGroup1",
    "/aws/logGroup2"
  ]

  query_string = <<EOF
fields @timestamp, @message
| filter httpRequest.clientIp = "186.251.62.123"
| filter action = "BLOCK"
| sort @timestamp desc
EOF
}

resource "aws_cloudwatch_query_definition" "Methods" {
  name = "Methods"

  log_group_names = [
    "/aws/logGroup1",
    "/aws/logGroup2"
  ]

  query_string = <<EOF
stats count(*)as RequestCount by httpRequest.httpMethod as Method
| sort RequestCount desc
EOF
}
resource "aws_cloudwatch_query_definition" "country" {
  name = "country"

  log_group_names = [
    "/aws/logGroup1",
    "/aws/logGroup2"
  ]

  query_string = <<EOF
stats count(*) as RequestCount by httpRequest.country as Country
| sort RequestCount desc
EOF
}
resource "aws_cloudwatch_query_definition" "Request" {
  name = "Request"

  log_group_names = [
    "/aws/logGroup1",
    "/aws/logGroup2"
  ]

  query_string = <<EOF
parse @message /\{"name":"[Hh]ost\",\"value":\"(?<Host>[^"}]*)/
| stats count(*) as RequestCount by Host
| sort RequestCount desc
EOF
}
resource "aws_cloudwatch_query_definition" "clientIp" {
  name = "clientIp"

  log_group_names = [
    "/aws/logGroup1",
    "/aws/logGroup2"
  ]

  query_string = <<EOF
stats count(*) as RequestCount by httpRequest.clientIp as ClientIP
| sort RequestCount desc
EOF
}
resource "aws_cloudwatch_query_definition" "Block_por_Role" {
  name = "Block por Role"

  log_group_names = [
    "/aws/logGroup1",
    "/aws/logGroup2"
  ]

  query_string = <<EOF
fields httpRequest.clientIp as ClientIP, httpRequest.country as Country, httpRequest.uri as URI, terminatingRuleId as Rule, action as Action
| filter action = "BLOCK"
| stats count(*) as RequestCount by Country, ClientIP, URI, Rule, Action
| sort RequestCount desc
EOF
}
resource "aws_cloudwatch_query_definition" "Path_por_IP" {
  name = "Path por IP"

  log_group_names = [
    "/aws/logGroup1",
    "/aws/logGroup2"
  ]

  query_string = <<EOF
fields httpRequest.clientIp as ClientIP, httpRequest.country as Country, httpRequest.uri as URI, terminatingRuleId as Rule
| filter httpRequest.clientIp = "191.135.83.85"
| stats count(*) as RequestCount by Country, ClientIP, URI, Rule
| sort RequestCount desc
EOF
}
resource "aws_cloudwatch_query_definition" "Block_por_Host" {
  name = "Block por Host"

  log_group_names = [
    "/aws/logGroup1",
    "/aws/logGroup2"
  ]

  query_string = <<EOF
parse @message /\{"name":"[Hh]ost\",\"value":\"(?<Host>[^"}]*)/
| filter Host = "www.trt4.jus.br"
| filter action = "BLOCK"
| fields terminatingRuleId as Rule, action, httpRequest.country as Country, httpRequest.clientIp as ClientIP, httpRequest.uri as URI
EOF
}
resource "aws_cloudwatch_query_definition" "Block_por_origem_Request_ID" {
  name = "Block por origem x Request ID"

  log_group_names = [
    "/aws/logGroup1",
    "/aws/logGroup2"
  ]

  query_string = <<EOF
fields terminatingRuleId as Rule, action, httpRequest.country as Country, httpRequest.clientIp as ClientIP, httpRequest.uri as URI
| filter httpRequest.requestId = "iv3ZZQS1jqn_g0vXnkRSie-fXwCbo4MY4VBPLujwiuX0U48LjF4MWg=="
| sort RequestCount desc
EOF
}
resource "aws_cloudwatch_query_definition" "count_por_origem_Request_ID" {
  name = "Count por origem x Request ID"

  log_group_names = [
    "/aws/logGroup1",
    "/aws/logGroup2"
  ]

  query_string = <<EOF
fields terminatingRuleId as Rule, action, httpRequest.country as Country, httpRequest.clientIp as ClientIP, httpRequest.uri as URI
| filter httpRequest.requestId = "V38Y0tDvsQDZO5SDYguA-hyxjB1W3b817rr7ITYx-W3rO-fbY-N90w=="
| stats count(*) as RequestCount by httpRequest.uri 
| sort RequestCount desc
EOF
}
resource "aws_cloudwatch_query_definition" "Count_per_Action" {
  name = "Count per Action"

  log_group_names = [
    "/aws/logGroup1",
    "/aws/logGroup2"
  ]

  query_string = <<EOF
fields terminatingRuleId as Rule, action, httpRequest.country as Country, httpRequest.clientIp as ClientIP, httpRequest.uri as URI
| filter httpRequest.requestId = "V38Y0tDvsQDZO5SDYguA-hyxjB1W3b817rr7ITYx-W3rO-fbY-N90w=="
| stats count(*) as RequestCount by httpRequest.uri 
| sort RequestCount desc
EOF
}
resource "aws_cloudwatch_query_definition" "filtro_IP_URI" {
  name = "Filtro por IP e por URI"

  log_group_names = [
    "/aws/logGroup1",
    "/aws/logGroup2"
  ]

  query_string = <<EOF
fields @timestamp, @message
| filter @message like "187.71.142.245" and @message like "/part-cas/login"
| sort @timestamp desc
| limit 20
EOF
}