resource "aws_ssm_parameter" "sns_ChangeDeliveryStatus" {
  name  = "/200OK/SNS/DeliveryStatus"
  type  = "String"
  value = aws_sns_topic.DeliveryStatusChange.arn
}
resource "aws_ssm_parameter" "kinesis_data_stream" {
  name  = "/200OK/Kinesis/Data_Stream_Name"
  type  = "String"
  value = aws_kinesis_stream.location_stream.name
}