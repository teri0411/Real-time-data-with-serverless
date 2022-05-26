resource "aws_sns_topic" "DeliveryStatusChange" {
  name = "DeliveryStatusChange"
}

# resource "aws_sns_topic" "NotificationSend" {
#   name = "NotificationSend"
# }