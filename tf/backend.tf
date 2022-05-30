terraform {
  backend "s3" {
    bucket         = "terraform-backend-for-200ok"       # s3 bucket 이름
    key            = "terraform/200OK/terraform.tfstate" # s3 내에서 저장되는 경로를 의미합니다.
    region         = "ap-northeast-2"
    encrypt        = true
    dynamodb_table = "terraform-lock"
    profile        = "default"
  }
}