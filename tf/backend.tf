terraform {
  backend "s3" {
    bucket         = "rupin-s3-bucket"       # s3 bucket 이름
    key            = "terraform/rupin/terraform.tfstate" # s3 내에서 저장되는 경로를 의미합니다.
    region         = "ap-northeast-2"
    encrypt        = true
    dynamodb_table = "terraform_lock"
    #profile        = "rupin"
  }
}