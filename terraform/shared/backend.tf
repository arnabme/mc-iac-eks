terraform {
  required_providers {
    aws = {
        region = "eu-north-1"
    }
  }
  backend "s3" {
    bucket         = "mc-ias-eks"
    key            = "mc-ias-eks"
    region         = "eu-north-1"
    encrypt        = true
    dynamodb_table = "mc-iac-ekse" # Optional DynamoDB table for state locking
  }
}


# backend "s3" {
#     bucket         = "mc-ias-eks" # Replace with your S3 bucket name
#     key            = "mc-iac-eks"
#     region         = "eu-north-1" # Or your desired default region
#     encrypt        = true
#     dynamodb_table = "mc-iac-eks" # Replace with your DynamoDB table name (must have LockID as primary key)
# }