resource "aws_opensearch_domain" "delivery_cluster" {
  domain_name = "delivery"
  cluster_config {
    instance_count         = 1
    zone_awareness_enabled = false
    instance_type          = "t3.small.search"

  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }

  vpc_options {
    security_group_ids = [aws_security_group.es_sg.id]
    subnet_ids         = [aws_subnet.twohundreadok-private-subnet.id]
  }

#   access_policies = <<CONFIG
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Action": "es:*",
#             "Principal": "*",
#             "Effect": "Allow",
#             "Resource": "${aws_kinesis_firehose_delivery_stream.location-kinesis-firehose-es.arn}"
#         }
#     ]
# }
# CONFIG

  tags = {
    Domain = "delivery"
  }
}

resource "aws_security_group" "es_sg" {
  name        = "es_sg"
  description = "Security Group for Elasticsearch"
  vpc_id      = aws_vpc.twohundreadok-vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["${aws_vpc.twohundreadok-vpc.cidr_block}"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "es_sg"
  }
}

