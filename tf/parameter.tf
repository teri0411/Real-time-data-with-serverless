resource "aws_ssm_parameter" "sns_ChangeDeliveryStatus" {
  name  = "/200OK/SNS/DeliveryStatus"
  type  = "String"
  value = aws_sns_topic.DeliveryStatusChange.arn
  overwrite = true
}
resource "aws_ssm_parameter" "kinesis_data_stream" {
  name  = "/200OK/Kinesis/Data_Stream_Name"
  type  = "String"
  value = aws_kinesis_stream.location_stream.name
  overwrite = true
}

resource "aws_ssm_parameter" "opensearch_endpoint" {
  name = "/200OK/Opensearch/Endpoint"
  type = "String"
  value = aws_opensearch_domain.delivery_cluster.endpoint
  overwrite = true
}

resource "aws_ssm_parameter" "opensearch_arn" {
  name = "/200OK/Opensearch/Arn"
  type = "String"
  value = aws_opensearch_domain.delivery_cluster.arn
  overwrite = true
}

resource "aws_ssm_parameter" "sns_NotificationSend" {
  name = "/200OK/SNS/NotificationSend"
  type = "String"
  value = aws_sns_topic.NotificationSend.arn
  overwrite = true
}

resource "aws_ssm_parameter" "securityGroup_id" {
  name = "/200OK/Security_Group/ID"
  type = "String"
  value = aws_security_group.lambda_sg.id
  overwrite = true
}

resource "aws_ssm_parameter" "subnet_id" {
  name = "/200OK/subnet/ID"
  type = "String"
  value = aws_subnet.twohundreadok-public-subnet.id
  overwrite = true
}
