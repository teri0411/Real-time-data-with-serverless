resource "aws_sns_topic" "DeliveryStatusChange" {
  name = "DeliveryStatusChange"
}

resource "aws_sns_topic" "NotificationSend" {
  name = "NotificationSend"
}

resource "aws_sns_topic_subscription" "sendNoti_toUser" {
  topic_arn = aws_sns_topic.NotificationSend.arn
  protocol  = "email"
  endpoint  = "goaheadman@naver.com"
}