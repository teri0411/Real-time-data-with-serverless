# resource "aws_elasticsearch_domain" "delivery_cluster" {
#   domain_name = "es-test"

#   cluster_config {
#     instance_count         = 2
#     zone_awareness_enabled = true
#     instance_type          = "t2.small.elasticsearch"
#   }

#   ebs_options {
#     ebs_enabled = true
#     volume_size = 10
#   }

#   vpc_options {
#     security_group_ids = [aws_security_group.first.id]
#     subnet_ids         = [aws_subnet.first.id, aws_subnet.second.id]
#   }
# }