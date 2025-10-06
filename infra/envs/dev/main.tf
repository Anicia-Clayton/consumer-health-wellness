module "ddb_kms" {
  source       = "../../modules/ddb_kms"
  project_name = var.project_name
  environment  = var.environment
  tags         = var.tags
}

module "api_lambda" {
  source       = "../../modules/api_lambda"
  project_name = var.project_name
  environment  = var.environment
  tags         = var.tags
}

module "aws_config_baseline" {
  source       = "../../modules/aws_config_baseline"
  project_name = var.project_name
  environment  = var.environment
  tags         = var.tags
}

output "api_base_url" { value = module.api_lambda.api_base_url }
output "config_logs_bucket" { value = module.aws_config_baseline.config_logs_bucket }
