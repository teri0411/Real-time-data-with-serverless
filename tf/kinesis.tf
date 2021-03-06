resource "aws_kinesis_stream" "location_stream" {
  name             = "location_stream"
  retention_period = 24

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",            
  ]

  stream_mode_details {
    stream_mode = "ON_DEMAND"
  }

  tags = {
    Environment = "dev"
  }
}


resource "aws_iam_role_policy" "firehose-opensearch" {
  name   = "firehose-opensearch"
  role   = aws_iam_role.firehose_role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "glue:GetTable",
                "glue:GetTableVersion",
                "glue:GetTableVersions"
            ],
            "Resource": [
                "arn:aws:glue:ap-northeast-2:889058321615:catalog",
                "arn:aws:glue:ap-northeast-2:889058321615:database/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%",
                "arn:aws:glue:ap-northeast-2:889058321615:table/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
            ]
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "s3:AbortMultipartUpload",
                "s3:GetBucketLocation",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:ListBucketMultipartUploads",
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::location-backup-bucket",
                "arn:aws:s3:::location-backup-bucket/*"
            ]
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "lambda:InvokeFunction",
                "lambda:GetFunctionConfiguration"
            ],
            "Resource": "arn:aws:lambda:ap-northeast-2:889058321615:function:%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
        },
        {
            "Effect": "Allow",
            "Action": [
                "kms:GenerateDataKey",
                "kms:Decrypt"
            ],
            "Resource": [
                "arn:aws:kms:ap-northeast-2:889058321615:key/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
            ],
            "Condition": {
                "StringEquals": {
                    "kms:ViaService": "s3.ap-northeast-2.amazonaws.com"
                },
                "StringLike": {
                    "kms:EncryptionContext:aws:s3:arn": [
                        "arn:aws:s3:::%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/*",
                        "arn:aws:s3:::%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
                    ]
                }
            }
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:ap-northeast-2:889058321615:log-group:/aws/kinesisfirehose/datatolambda_firehose:log-stream:*",
                "arn:aws:logs:ap-northeast-2:889058321615:log-group:%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%:log-stream:*"
            ]
        },
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "kinesis:DescribeStream",
                "kinesis:GetShardIterator",
                "kinesis:GetRecords",
                "kinesis:ListShards"
            ],
            "Resource": "${aws_kinesis_stream.location_stream.arn}"
        },
        {
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt"
            ],
            "Resource": [
                "arn:aws:kms:ap-northeast-2:889058321615:key/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
            ],
            "Condition": {
                "StringEquals": {
                    "kms:ViaService": "kinesis.ap-northeast-2.amazonaws.com"
                },
                "StringLike": {
                    "kms:EncryptionContext:aws:kinesis:arn": "arn:aws:kinesis:ap-northeast-2:889058321615:stream/location_stream"
                }
            }
        }
    ]
}
EOF
}

resource "aws_iam_role" "firehose_role" {
  name = "firehose_role"

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

resource "aws_kinesis_firehose_delivery_stream" "location-kinesis-firehose-es" {
  depends_on = [aws_iam_role_policy.firehose-opensearch, aws_iam_role.firehose_role]

  name        = "location-kinesis-firehose-es"
  destination = "elasticsearch"

  s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.location-backup-bucket.arn
  }

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.location_stream.arn
    role_arn = aws_iam_role.firehose_role.arn
  } 

  elasticsearch_configuration {
    domain_arn = aws_opensearch_domain.delivery_cluster.arn
    role_arn   = aws_iam_role.firehose_role.arn
    index_name = "location"

    vpc_config {
      subnet_ids         = [aws_subnet.twohundreadok-private-subnet.id]
      security_group_ids = [aws_security_group.es_sg.id]
      role_arn           = aws_iam_role.firehose_role.arn
    }

    cloudwatch_logging_options {
      enabled = true
      log_group_name = "/aws/kinesisfirehose/location-kinesis-firehose-es"
      log_stream_name = "DestinationDelivery2"
    }
    
  }
}

resource "aws_cloudwatch_log_group" "location-kinesis-firehose-es" {
  name = "/aws/kinesisfirehose/location-kinesis-firehose-es"
}

resource "aws_s3_bucket" "location-backup-bucket" {
  bucket = "location-backup-bucket"
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.location-backup-bucket.id
  acl    = "private"
}

# kinesis firehose (HTTP Endpoint Destination)
resource "aws_kinesis_firehose_delivery_stream" "firehose-lambda" {
  name        = "firehose-lambda"
  destination = "http_endpoint"

  s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.location-backup-bucket.arn
  }

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.location_stream.arn
    role_arn = aws_iam_role.firehose_role.arn
  } 

  http_endpoint_configuration {
    url                = var.ENDPOINT_URL
    name               = "http_endpoint"
    buffering_size     = 5
    buffering_interval = 60
    role_arn           = aws_iam_role.firehose_role.arn
    s3_backup_mode     = "FailedDataOnly"

     request_configuration {
       content_encoding = "NONE"
     }
  }
}

resource "aws_iam_role_policy" "firehose-lambda" {
  name   = "opensearch"
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
        "${aws_opensearch_domain.delivery_cluster.arn}",
        "${aws_opensearch_domain.delivery_cluster.arn}*"
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
    },
    {
      "Effect": "Allow",
      "Action": [
        "kinesis:*"
      ],
      "Resource": "${aws_kinesis_stream.location_stream.arn}"
    }
  ]
}
EOF
}

resource "aws_cloudwatch_log_group" "firehose-lambda" {
  name = "/aws/kinesisfirehose/firehose-lambda"
}

resource "aws_cloudwatch_log_stream" "DestinationDelivery" {
  name           = "DestinationDelivery"
  log_group_name = aws_cloudwatch_log_group.firehose-lambda.name
}

resource "aws_cloudwatch_log_stream" "DestinationDelivery2" {
  name           = "DestinationDelivery2"
  log_group_name = aws_cloudwatch_log_group.location-kinesis-firehose-es.name
}