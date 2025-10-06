# Optional: protect the public API with WAF v2
module "api_waf" {
  source     = "../modules/api_waf"
  name       = "${var.project_name}-${var.environment}-waf"
  region     = var.aws_region
  api_id     = aws_apigatewayv2_api.http.id
  stage_name = "$default"
}
