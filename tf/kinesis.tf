resource "aws_kinesis_stream" "location_stream" {
  name             = "location_stream"
  # shard_count      = 2 
  retention_period = 24

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",            
  ]

  stream_mode_details {
    # stream_mode = "PROVISIONED"
    stream_mode = "ON_DEMAND"
  }

  tags = {
    Environment = "dev"
  }
}

resource "aws_iam_role_policy" "firehose-elasticsearch" {
  name   = "elasticsearch"
  role   = aws_iam_role.firehose_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "es:*"
      ],
      "Resource": [
        "${aws_elasticsearch_domain.delivery_cluster.arn}",
        "${aws_elasticsearch_domain.delivery_cluster.arn}/*"
      ]
        },
        {
          "Effect": "Allow",
          "Action": [
            "ec2:DescribeVpcs",
            "ec2:DescribeVpcAttribute",
            "ec2:DescribeSubnets",
            "ec2:DescribeSecurityGroups",
            "ec2:DescribeNetworkInterfaces",
            "ec2:CreateNetworkInterface",
            "ec2:CreateNetworkInterfacePermission",
            "ec2:DeleteNetworkInterface"
          ],
          "Resource": [
            "*"
          ]
        }
  ]
}
EOF
}

resource "aws_kinesis_firehose_delivery_stream" "terraform-kinesis-firehose-es" {
  depends_on = [aws_iam_role_policy.firehose-elasticsearch]

  name        = "terraform-kinesis-firehose-es"
  destination = "elasticsearch"
  s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.location-backup-bucket.arn
  }
  elasticsearch_configuration {
    domain_arn = aws_elasticsearch_domain.delivery_cluster.arn
    role_arn   = aws_iam_role.firehose_role.arn
    index_name = "location"
    type_name  = "location"

    vpc_config {
      subnet_ids         = [aws_subnet.twohundreadok-private-subnet.id, aws_subnet.twohundreadok-private-subnet-2.id]
      security_group_ids = [aws_security_group.es_sg.id]
      role_arn           = aws_iam_role.firehose_role.arn
    }
  }
}

resource "aws_s3_bucket" "location-backup-bucket" {
  bucket = "location-backup-bucket"
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.location-backup-bucket.id
  acl    = "private"
}

resource "aws_iam_role" "firehose_role" {
  name = "firehose_test_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}