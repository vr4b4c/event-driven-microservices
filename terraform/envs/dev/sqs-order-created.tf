resource "aws_sqs_queue" "order_created" {
  name                      = "order-created"
  delay_seconds             = 0
  max_message_size          = 262144
  message_retention_seconds = 86400
  receive_wait_time_seconds = 0
}
