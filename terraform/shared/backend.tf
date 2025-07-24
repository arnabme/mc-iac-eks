terraform {
  backend "s3" {
    bucket         = "S3_State_Bucket" # Replace with your S3 bucket name
    key            = "mc-iac-eks/terraform.tfstate"
    region         = "ap-south-1" # Or your desired default region
    encrypt        = true
    dynamodb_table = "MONGODB_LOCK_TABLE" # Replace with your DynamoDB table name (must have LockID as primary key)
  }
}