resource "aws_dynamodb_table" "orders" {
  name           = "orders"
  hash_key       = "order_id"
  read_capacity  = 1
  write_capacity = 1

 attribute {
    name = "order_id"
    type = "S"
  }
}
