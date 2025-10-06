resource "aws_kms_key" "ddb" {
  description = "${var.project_name}-${var.environment}-ddb-kms"
  enable_key_rotation = true
  deletion_window_in_days = 7
  tags = var.tags
}
resource "aws_dynamodb_table" "ingredients" {
  name         = "${var.project_name}-${var.environment}-ingredients"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "barcode"
  server_side_encryption { enabled = true, kms_key_arn = aws_kms_key.ddb.arn }
  attribute { name = "barcode" type = "S" }
  tags = merge(var.tags, { Component = "dynamodb" })
}
locals { samples = [
  { barcode = "000111222333", name = "FoamFresh Hand Soap",    ingredients = "Aqua, Sodium Laureth Sulfate, Cocamidopropyl Betaine, Fragrance" },
  { barcode = "111222333444", name = "SparkleClean Dish Soap", ingredients = "Water, Sodium Lauryl Sulfate, Sodium Chloride, Lemon Oil" }
]}
resource "aws_dynamodb_table_item" "seed" {
  for_each = { for s in local.samples : s.barcode => s }
  table_name = aws_dynamodb_table.ingredients.name
  hash_key   = "barcode"
  item = jsonencode({ barcode = { S = each.value.barcode }, name = { S = each.value.name }, ingredients = { S = each.value.ingredients } })
}
output "table_name" { value = aws_dynamodb_table.ingredients.name }
output "arn"        { value = aws_dynamodb_table.ingredients.arn }
