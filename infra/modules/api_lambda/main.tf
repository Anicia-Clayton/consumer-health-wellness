data "aws_iam_policy_document" "assume" {
  statement { actions = ["sts:AssumeRole"]; principals { type = "Service" identifiers = ["lambda.amazonaws.com"] } }
}
resource "aws_iam_role" "lambda_role" {
  name = "${var.project_name}-${var.environment}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.assume.json
  tags = var.tags
}
data "aws_iam_policy_document" "ddb_read" {
  statement { effect = "Allow"; actions = ["dynamodb:GetItem"]; resources = [module.ddb_kms.arn] }
}
resource "aws_iam_policy" "ddb_read" { name = "${var.project_name}-${var.environment}-ddb-read"; policy = data.aws_iam_policy_document.ddb_read.json }
resource "aws_iam_role_policy_attachment" "ddb" { role = aws_iam_role.lambda_role.name; policy_arn = aws_iam_policy.ddb_read.arn }
resource "aws_iam_role_policy_attachment" "basic" { role = aws_iam_role.lambda_role.name; policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole" }
resource "aws_lambda_function" "api" {
  function_name = "${var.project_name}-${var.environment}-ingredient-lookup"
  role = aws_iam_role.lambda_role.arn
  handler = "lambda_function.handler"
  runtime = "python3.11"
  filename = "${path.module}/package/lambda.zip"
  timeout = 8
  environment { variables = { TABLE_NAME = module.ddb_kms.table_name } }
  tags = var.tags
}
resource "aws_cloudwatch_log_group" "lg" { name = "/aws/lambda/${aws_lambda_function.api.function_name}"; retention_in_days = 14; tags = var.tags }
resource "aws_apigatewayv2_api" "http" { name = "${var.project_name}-${var.environment}-api"; protocol_type = "HTTP"; tags = var.tags }
resource "aws_apigatewayv2_integration" "int" { api_id = aws_apigatewayv2_api.http.id; integration_type = "AWS_PROXY"; integration_uri = aws_lambda_function.api.arn; payload_format_version = "2.0" }
resource "aws_apigatewayv2_route" "lookup" { api_id = aws_apigatewayv2_api.http.id; route_key = "GET /v1/ingredient"; target = "integrations/${aws_apigatewayv2_integration.int.id}" }
resource "aws_lambda_permission" "apigw" { statement_id="AllowInvoke"; action="lambda:InvokeFunction"; function_name=aws_lambda_function.api.function_name; principal="apigateway.amazonaws.com"; source_arn="${aws_apigatewayv2_api.http.execution_arn}/*/*" }
resource "aws_apigatewayv2_stage" "auto" { api_id = aws_apigatewayv2_api.http.id; name = "$default"; auto_deploy = true; tags = var.tags }
output "api_base_url" { value = aws_apigatewayv2_api.http.api_endpoint }
