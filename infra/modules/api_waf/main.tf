variable "name"       { type = string }
variable "region"     { type = string }
variable "api_id"     { type = string }
variable "stage_name" { type = string  default = "$default" }

resource "aws_wafv2_web_acl" "this" {
  name  = var.name
  scope = "REGIONAL"
  default_action { allow {} }
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.name}-metrics"
    sampled_requests_enabled   = true
  }
  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 1
    override_action { none {} }
    statement { managed_rule_group_statement { vendor_name = "AWS" name = "AWSManagedRulesCommonRuleSet" } }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "common"
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = "RateLimit"
    priority = 2
    action { block {} }
    statement { rate_based_statement { limit = 1000 aggregate_key_type = "IP" } }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "ratelimit"
      sampled_requests_enabled   = true
    }
  }
}

# Associate to API Gateway HTTP API stage
resource "aws_wafv2_web_acl_association" "assoc" {
  resource_arn = "arn:aws:apigateway:${var.region}::/apis/${var.api_id}/stages/${var.stage_name}"
  web_acl_arn  = aws_wafv2_web_acl.this.arn
}
output "web_acl_arn" { value = aws_wafv2_web_acl.this.arn }
