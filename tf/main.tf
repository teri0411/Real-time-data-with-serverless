provider "aws" {
  region = "ap-northeast-2"
}

# S3 bucket for backend
resource "aws_s3_bucket" "tfstate" {
  bucket = "terraform-backend-for-200ok"
}

resource "aws_s3_bucket_policy" "allow_access_from_Administrators" {
  bucket = aws_s3_bucket.tfstate.id
  policy = data.aws_iam_policy_document.allow_access_from_Administrators.json
}

data "aws_iam_policy_document" "allow_access_from_Administrators" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["889058321615"]
    }

    actions = [
      "s3:ListBucket","s3:GetObject", "s3:PutObject"
    ]

    resources = [
      aws_s3_bucket.tfstate.arn,
      "${aws_s3_bucket.tfstate.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.tfstate.id
  versioning_configuration {
    status = "Enabled"
  }
}



# DynamoDB for terraform state lock
resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "terraform-lock"
  hash_key       = "LockID"
  billing_mode   = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}